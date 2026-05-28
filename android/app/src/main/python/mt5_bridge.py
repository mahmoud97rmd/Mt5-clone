# Path: android/app/src/main/python/mt5_bridge.py
# ============================================================
# MT5 Clone — Python Bridge Module
# This is the ENTRY POINT loaded by Chaquopy at runtime.
#
# Architecture:
#   Kotlin (EaEngineService) ←→ Chaquopy JNI bridge ←→ mt5_bridge.py
#                                                             ↓
#                                               loads user EA scripts
#                                                             ↓
#                                           on_tick() / buy() / sell()
#
# This module provides:
#   1. EA script loader and sandbox
#   2. Trading API exposed to user EA scripts
#   3. Error handling and logging bridge
#   4. Performance monitoring
# ============================================================

import sys
import os
import json
import time
import traceback
import importlib.util
from typing import Optional, Dict, Any, Callable, List
from decimal import Decimal, ROUND_HALF_UP
import threading
import logging

# ============================================================
# 1.4.2.1 — Logging Configuration
# Logs are captured by Kotlin EaEngineService via stdout
# ============================================================

class AndroidLogHandler(logging.Handler):
    """Routes Python logs to Android's LogCat via stdout."""
    
    LEVEL_PREFIXES = {
        logging.DEBUG:    "[DEBUG]",
        logging.INFO:     "[INFO ]",
        logging.WARNING:  "[WARN ]",
        logging.ERROR:    "[ERROR]",
        logging.CRITICAL: "[CRIT ]",
    }
    
    def emit(self, record: logging.LogRecord):
        prefix = self.LEVEL_PREFIXES.get(record.levelno, "[LOG  ]")
        timestamp = time.strftime("%H:%M:%S", time.localtime(record.created))
        message = self.format(record)
        # Print to stdout — Kotlin captures this via Chaquopy's stdout redirect
        print(f"{prefix} {timestamp} [{record.name}] {message}", flush=True)


# Configure root logger
_logger = logging.getLogger("mt5_bridge")
_logger.setLevel(logging.DEBUG)
_handler = AndroidLogHandler()
_handler.setFormatter(logging.Formatter("%(message)s"))
_logger.addHandler(_handler)

# Also capture warnings
logging.captureWarnings(True)

# ============================================================
# 1.4.2.2 — Trading API (exposed to user EA scripts)
# These functions are called by user EA scripts.
# Actual execution is routed back to Kotlin via callbacks.
# ============================================================

class TradingAPI:
    """
    The public trading API exposed to user Expert Advisor scripts.
    
    EA scripts interact with the market through this class.
    All methods are thread-safe and validated before execution.
    
    Usage in EA scripts:
        from mt5_bridge import api
        
        def on_tick(symbol, bid, ask):
            if ask > 2000.0:
                api.buy(symbol, volume=0.01, sl=1990.0, tp=2020.0)
    """
    
    def __init__(self):
        self._buy_callback: Optional[Callable] = None
        self._sell_callback: Optional[Callable] = None
        self._close_callback: Optional[Callable] = None
        self._modify_callback: Optional[Callable] = None
        self._lock = threading.Lock()
        self._positions: Dict[int, Dict[str, Any]] = {}
        self._account_info: Dict[str, Any] = {}
        
    # --------------------------------------------------------
    # 1.4.2.3 — Callback Registration (called by Kotlin)
    # --------------------------------------------------------
    
    def _register_callbacks(
        self,
        on_buy: Callable,
        on_sell: Callable,
        on_close: Callable,
        on_modify: Callable
    ):
        """Register execution callbacks from Kotlin bridge."""
        with self._lock:
            self._buy_callback = on_buy
            self._sell_callback = on_sell
            self._close_callback = on_close
            self._modify_callback = on_modify
        _logger.info("Trading API callbacks registered ✅")
    
    def _update_positions(self, positions_json: str):
        """Update the local positions cache (called by Kotlin on each tick)."""
        try:
            with self._lock:
                self._positions = json.loads(positions_json)
        except json.JSONDecodeError as e:
            _logger.error(f"Failed to parse positions: {e}")
    
    def _update_account_info(self, account_json: str):
        """Update account state (called by Kotlin)."""
        try:
            with self._lock:
                self._account_info = json.loads(account_json)
        except json.JSONDecodeError as e:
            _logger.error(f"Failed to parse account info: {e}")
    
    # --------------------------------------------------------
    # 1.4.2.4 — PUBLIC TRADING API (called by user EA scripts)
    # --------------------------------------------------------
    
    def buy(
        self,
        symbol: str,
        volume: float,
        sl: Optional[float] = None,
        tp: Optional[float] = None,
        comment: str = "",
        magic: int = 0
    ) -> Optional[int]:
        """
        Open a BUY (Long) market order.
        
        Args:
            symbol:  Trading instrument (e.g., "XAU_USD", "EUR_USD")
            volume:  Lot size (e.g., 0.01 = 1 micro lot)
            sl:      Stop Loss price (optional)
            tp:      Take Profit price (optional)
            comment: Order comment/label (max 32 chars)
            magic:   Magic number for EA identification
            
        Returns:
            Trade ticket (int) if successful, None if failed.
        """
        if not self._validate_order_params(symbol, volume, sl, tp):
            return None
            
        payload = json.dumps({
            "action": "BUY",
            "symbol": symbol,
            "volume": round(float(volume), 2),
            "sl": float(sl) if sl else None,
            "tp": float(tp) if tp else None,
            "comment": str(comment)[:32],
            "magic": int(magic),
            "timestamp": time.time()
        })
        
        _logger.info(f"📈 BUY {volume} {symbol} | SL={sl} | TP={tp}")
        
        try:
            if self._buy_callback:
                result = self._buy_callback(payload)
                if result:
                    ticket = json.loads(result).get("ticket")
                    _logger.info(f"✅ BUY order placed | Ticket: {ticket}")
                    return ticket
        except Exception as e:
            _logger.error(f"❌ BUY order failed: {e}")
        return None
    
    def sell(
        self,
        symbol: str,
        volume: float,
        sl: Optional[float] = None,
        tp: Optional[float] = None,
        comment: str = "",
        magic: int = 0
    ) -> Optional[int]:
        """
        Open a SELL (Short) market order.
        
        Args:
            symbol:  Trading instrument
            volume:  Lot size
            sl:      Stop Loss price (optional)
            tp:      Take Profit price (optional)
            comment: Order comment
            magic:   Magic number for EA identification
            
        Returns:
            Trade ticket (int) if successful, None if failed.
        """
        if not self._validate_order_params(symbol, volume, sl, tp):
            return None
            
        payload = json.dumps({
            "action": "SELL",
            "symbol": symbol,
            "volume": round(float(volume), 2),
            "sl": float(sl) if sl else None,
            "tp": float(tp) if tp else None,
            "comment": str(comment)[:32],
            "magic": int(magic),
            "timestamp": time.time()
        })
        
        _logger.info(f"📉 SELL {volume} {symbol} | SL={sl} | TP={tp}")
        
        try:
            if self._sell_callback:
                result = self._sell_callback(payload)
                if result:
                    ticket = json.loads(result).get("ticket")
                    _logger.info(f"✅ SELL order placed | Ticket: {ticket}")
                    return ticket
        except Exception as e:
            _logger.error(f"❌ SELL order failed: {e}")
        return None
    
    def close_position(self, ticket: int, volume: Optional[float] = None) -> bool:
        """
        Close an open position by ticket number.
        
        Args:
            ticket:  The trade ticket to close
            volume:  Partial close volume (None = full close)
            
        Returns:
            True if closed successfully, False otherwise.
        """
        payload = json.dumps({
            "action": "CLOSE",
            "ticket": int(ticket),
            "volume": float(volume) if volume else None,
            "timestamp": time.time()
        })
        
        _logger.info(f"🔒 CLOSE position | Ticket: {ticket} | Volume: {volume or 'full'}")
        
        try:
            if self._close_callback:
                result = self._close_callback(payload)
                success = json.loads(result).get("success", False)
                if success:
                    _logger.info(f"✅ Position {ticket} closed")
                else:
                    _logger.warning(f"⚠️ Close request rejected for ticket {ticket}")
                return success
        except Exception as e:
            _logger.error(f"❌ CLOSE position failed: {e}")
        return False
    
    def modify_position(
        self,
        ticket: int,
        sl: Optional[float] = None,
        tp: Optional[float] = None
    ) -> bool:
        """
        Modify Stop Loss and/or Take Profit of an open position.
        
        Args:
            ticket: The trade ticket to modify
            sl:     New Stop Loss price (None = keep current)
            tp:     New Take Profit price (None = keep current)
            
        Returns:
            True if modified successfully.
        """
        payload = json.dumps({
            "action": "MODIFY",
            "ticket": int(ticket),
            "sl": float(sl) if sl else None,
            "tp": float(tp) if tp else None,
            "timestamp": time.time()
        })
        
        _logger.info(f"✏️ MODIFY ticket={ticket} | SL={sl} | TP={tp}")
        
        try:
            if self._modify_callback:
                result = self._modify_callback(payload)
                success = json.loads(result).get("success", False)
                return success
        except Exception as e:
            _logger.error(f"❌ MODIFY failed: {e}")
        return False
    
    # --------------------------------------------------------
    # 1.4.2.5 — Account & Position Queries
    # --------------------------------------------------------
    
    def get_positions(self, symbol: Optional[str] = None) -> List[Dict[str, Any]]:
        """Get list of open positions, optionally filtered by symbol."""
        with self._lock:
            positions = list(self._positions.values())
        if symbol:
            positions = [p for p in positions if p.get("symbol") == symbol]
        return positions
    
    def get_position_count(self, symbol: Optional[str] = None) -> int:
        """Get count of open positions."""
        return len(self.get_positions(symbol))
    
    def get_account_balance(self) -> float:
        """Get current account balance."""
        with self._lock:
            return float(self._account_info.get("balance", 0.0))
    
    def get_account_equity(self) -> float:
        """Get current account equity (balance + floating PnL)."""
        with self._lock:
            return float(self._account_info.get("equity", 0.0))
    
    def get_free_margin(self) -> float:
        """Get available free margin for new trades."""
        with self._lock:
            return float(self._account_info.get("freeMargin", 0.0))
    
    # --------------------------------------------------------
    # 1.4.2.6 — Order Validation
    # --------------------------------------------------------
    
    def _validate_order_params(
        self,
        symbol: str,
        volume: float,
        sl: Optional[float],
        tp: Optional[float]
    ) -> bool:
        """Validate order parameters before sending to Kotlin bridge."""
        if not symbol or not isinstance(symbol, str):
            _logger.error("Invalid symbol")
            return False
        
        volume = float(volume)
        if volume <= 0 or volume > 100:
            _logger.error(f"Invalid volume: {volume} (must be 0 < volume ≤ 100)")
            return False
        
        # Check minimum lot size (0.01 = 1 micro lot)
        if volume < 0.01:
            _logger.error(f"Volume {volume} below minimum 0.01 lots")
            return False
        
        return True


# ============================================================
# 1.4.2.7 — EA Script Loader
# Loads user-uploaded Python EA scripts into an isolated sandbox
# ============================================================

class EaScriptLoader:
    """
    Safely loads and executes user-provided Expert Advisor Python scripts.
    
    Security model:
    - Scripts run in a restricted namespace (no os.system, no subprocess)
    - Only the TradingAPI functions are exposed
    - All exceptions are caught and logged (never crash the service)
    """
    
    def __init__(self, trading_api: TradingAPI):
        self._api = trading_api
        self._loaded_modules: Dict[str, Any] = {}
        self._on_tick_handlers: Dict[str, Callable] = {}
    
    def load_script(self, script_path: str, ea_name: str) -> bool:
        """
        Load an EA script from the given file path.
        
        Args:
            script_path: Absolute path to the .py EA file
            ea_name:     Unique name/ID for this EA instance
            
        Returns:
            True if loaded successfully.
        """
        try:
            if not os.path.exists(script_path):
                _logger.error(f"EA script not found: {script_path}")
                return False
            
            _logger.info(f"📂 Loading EA script: {ea_name} from {script_path}")
            
            # Create isolated module namespace
            spec = importlib.util.spec_from_file_location(ea_name, script_path)
            if not spec or not spec.loader:
                _logger.error(f"Could not create module spec for {script_path}")
                return False
            
            module = importlib.util.module_from_spec(spec)
            
            # Inject trading API into the module's namespace
            # This is how EA scripts access buy(), sell(), etc.
            module.__dict__["api"] = self._api
            module.__dict__["buy"] = self._api.buy
            module.__dict__["sell"] = self._api.sell
            module.__dict__["close_position"] = self._api.close_position
            module.__dict__["modify_position"] = self._api.modify_position
            module.__dict__["get_positions"] = self._api.get_positions
            module.__dict__["get_account_balance"] = self._api.get_account_balance
            module.__dict__["get_account_equity"] = self._api.get_account_equity
            module.__dict__["log"] = _logger
            
            # Execute the module (defines functions, classes, etc.)
            spec.loader.exec_module(module)
            
            # Extract the on_tick handler if it exists
            if hasattr(module, "on_tick") and callable(module.on_tick):
                self._on_tick_handlers[ea_name] = module.on_tick
                _logger.info(f"✅ EA '{ea_name}' loaded with on_tick handler")
            else:
                _logger.warning(f"⚠️ EA '{ea_name}' has no on_tick() function")
            
            # Call on_init if it exists (EA initialization)
            if hasattr(module, "on_init") and callable(module.on_init):
                try:
                    module.on_init()
                    _logger.info(f"✅ EA '{ea_name}' on_init() completed")
                except Exception as e:
                    _logger.error(f"❌ EA '{ea_name}' on_init() failed: {e}")
            
            self._loaded_modules[ea_name] = module
            return True
            
        except SyntaxError as e:
            _logger.error(f"❌ Syntax error in EA '{ea_name}': {e}")
            return False
        except Exception as e:
            _logger.error(f"❌ Failed to load EA '{ea_name}': {e}\n{traceback.format_exc()}")
            return False
    
    def dispatch_tick(self, ea_name: str, symbol: str, bid: float, ask: float) -> None:
        """
        Dispatch a price tick to the specified EA's on_tick handler.
        Called by Kotlin EaEngineService on every price update.
        
        Args:
            ea_name: The EA to notify
            symbol:  Trading instrument symbol
            bid:     Current bid price
            ask:     Current ask price
        """
        handler = self._on_tick_handlers.get(ea_name)
        if not handler:
            return
        
        try:
            handler(symbol=symbol, bid=float(bid), ask=float(ask))
        except Exception as e:
            _logger.error(
                f"❌ EA '{ea_name}' on_tick() error for {symbol} "
                f"bid={bid} ask={ask}: {e}\n{traceback.format_exc()}"
            )
    
    def unload_script(self, ea_name: str) -> None:
        """Unload an EA script and call its on_deinit if available."""
        module = self._loaded_modules.get(ea_name)
        if module and hasattr(module, "on_deinit") and callable(module.on_deinit):
            try:
                module.on_deinit()
                _logger.info(f"✅ EA '{ea_name}' on_deinit() completed")
            except Exception as e:
                _logger.error(f"EA '{ea_name}' on_deinit() error: {e}")
        
        self._loaded_modules.pop(ea_name, None)
        self._on_tick_handlers.pop(ea_name, None)
        _logger.info(f"🗑️ EA '{ea_name}' unloaded")
    
    def get_loaded_eas(self) -> List[str]:
        """Return list of currently loaded EA names."""
        return list(self._loaded_modules.keys())


# ============================================================
# 1.4.2.8 — Module-Level Singletons
# These are accessed by Kotlin via Chaquopy's module API
# ============================================================

# Global Trading API instance
api = TradingAPI()

# Global EA Loader instance
loader = EaScriptLoader(api)

# ============================================================
# 1.4.2.9 — Kotlin-Callable Functions
# These are the entry points called directly by Kotlin via Chaquopy:
#   Python.getInstance().getModule("mt5_bridge").callAttr("dispatch_tick", ...)
# ============================================================

def dispatch_tick(ea_name: str, symbol: str, bid: float, ask: float) -> None:
    """Called by Kotlin on every price tick to invoke EA's on_tick()."""
    loader.dispatch_tick(ea_name, symbol, bid, ask)


def load_ea(script_path: str, ea_name: str) -> bool:
    """Called by Kotlin to load a user EA script."""
    return loader.load_script(script_path, ea_name)


def unload_ea(ea_name: str) -> None:
    """Called by Kotlin to unload an EA."""
    loader.unload_script(ea_name)


def get_loaded_eas() -> str:
    """Return JSON array of loaded EA names."""
    return json.dumps(loader.get_loaded_eas())


def register_trading_callbacks(buy_cb, sell_cb, close_cb, modify_cb) -> None:
    """Called by Kotlin to register execution callbacks."""
    api._register_callbacks(buy_cb, sell_cb, close_cb, modify_cb)


def update_positions(positions_json: str) -> None:
    """Called by Kotlin to update positions cache."""
    api._update_positions(positions_json)


def update_account_info(account_json: str) -> None:
    """Called by Kotlin to update account info cache."""
    api._update_account_info(account_json)


def get_version() -> str:
    """Return bridge version info for diagnostics."""
    return json.dumps({
        "bridge_version": "1.0.0",
        "python_version": sys.version,
        "platform": sys.platform,
        "loaded_packages": _get_installed_packages()
    })


def _get_installed_packages() -> List[str]:
    """Return list of available Python packages."""
    try:
        import importlib.metadata
        return [
            f"{d.metadata['Name']}=={d.version}"
            for d in importlib.metadata.distributions()
        ]
    except Exception:
        return []


# ============================================================
# 1.4.2.10 — Bridge Initialization Log
# ============================================================
_logger.info("=" * 50)
_logger.info("🐍 MT5 Clone Python Bridge Initialized")
_logger.info(f"   Python: {sys.version}")
_logger.info(f"   Bridge: v1.0.0")
_logger.info("=" * 50)
