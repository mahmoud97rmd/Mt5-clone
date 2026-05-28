# Path: android/python_scripts/ea_templates/simple_ma_crossover_ea.py
# ============================================================
# MT5 Clone — Example Expert Advisor Template
# Strategy: Simple Moving Average Crossover on XAUUSD
#
# This file serves as:
#   1. A working EA example for users
#   2. Documentation of the EA API
#   3. A reference for the MT5 Clone EA Engine
#
# HOW TO USE:
#   1. Upload this file via the EA Manager screen
#   2. Assign it to XAU_USD pair
#   3. Set your Magic Number and Lot Size
#   4. Press "Start EA"
#
# The EA Engine will call on_tick() on every price update.
# ============================================================

# ─────────────────────────────────────────────────────────────
# PARAMETERS (configurable from EA Manager UI)
# These can be overridden by the EA Manager before loading
# ─────────────────────────────────────────────────────────────
MAGIC_NUMBER = 12345          # Unique ID for orders from this EA
LOT_SIZE     = 0.01           # Trade volume (0.01 = 1 micro lot)
FAST_MA      = 9              # Fast MA period
SLOW_MA      = 21             # Slow MA period
SYMBOL       = "XAU_USD"      # Trading instrument
MAX_TRADES   = 1              # Max simultaneous positions
SL_PIPS      = 150            # Stop Loss in pips (XAU pip = 0.10)
TP_PIPS      = 300            # Take Profit in pips
PIP_SIZE     = 0.10           # 1 pip = $0.10 for XAUUSD

# ─────────────────────────────────────────────────────────────
# STATE (persists between on_tick() calls)
# ─────────────────────────────────────────────────────────────
_price_history = []           # List of recent ask prices
_last_signal   = None         # Last signal: "BUY", "SELL", or None


def on_init():
    """
    Called ONCE when the EA is loaded.
    Use for initialization: load history, connect APIs, log startup.
    """
    log.info(f"🤖 MA Crossover EA initialized")
    log.info(f"   Symbol: {SYMBOL}")
    log.info(f"   Fast MA: {FAST_MA} | Slow MA: {SLOW_MA}")
    log.info(f"   Lot Size: {LOT_SIZE} | Magic: {MAGIC_NUMBER}")


def on_tick(symbol: str, bid: float, ask: float):
    """
    Called on EVERY price tick.
    
    Args:
        symbol: The instrument that ticked (e.g., "XAU_USD")
        bid:    Current bid price
        ask:    Current ask price
    """
    global _price_history, _last_signal
    
    # Only process ticks for our target symbol
    if symbol != SYMBOL:
        return
    
    # Accumulate price history (use mid price)
    mid_price = (bid + ask) / 2.0
    _price_history.append(mid_price)
    
    # Keep only as much history as we need
    max_history = max(FAST_MA, SLOW_MA) + 10
    if len(_price_history) > max_history:
        _price_history = _price_history[-max_history:]
    
    # Need enough data to calculate both MAs
    if len(_price_history) < SLOW_MA:
        return
    
    # Calculate Moving Averages
    fast_ma = _calculate_sma(_price_history, FAST_MA)
    slow_ma = _calculate_sma(_price_history, SLOW_MA)
    
    if fast_ma is None or slow_ma is None:
        return
    
    # Detect crossover signal
    signal = _detect_crossover(fast_ma, slow_ma)
    
    if signal and signal != _last_signal:
        _last_signal = signal
        _execute_signal(signal, bid, ask)


def on_deinit():
    """
    Called when the EA is stopped or unloaded.
    Clean up resources, close open positions if needed.
    """
    log.info("🛑 MA Crossover EA stopping...")
    # Optional: close all positions on shutdown
    # positions = get_positions(SYMBOL)
    # for pos in positions:
    #     if pos.get("magic") == MAGIC_NUMBER:
    #         close_position(pos["ticket"])


# ─────────────────────────────────────────────────────────────
# INTERNAL LOGIC
# ─────────────────────────────────────────────────────────────

def _calculate_sma(prices: list, period: int) -> float | None:
    """Calculate Simple Moving Average for the given period."""
    if len(prices) < period:
        return None
    return sum(prices[-period:]) / period


def _detect_crossover(fast_ma: float, slow_ma: float) -> str | None:
    """
    Detect if Fast MA has crossed over Slow MA.
    Returns: "BUY" for bullish crossover, "SELL" for bearish, None for no signal.
    """
    if fast_ma > slow_ma:
        return "BUY"
    elif fast_ma < slow_ma:
        return "SELL"
    return None


def _execute_signal(signal: str, bid: float, ask: float):
    """Execute a trade based on the detected crossover signal."""
    # Check if we already have max positions open
    current_positions = get_positions(SYMBOL)
    ea_positions = [p for p in current_positions if p.get("magic") == MAGIC_NUMBER]
    
    if len(ea_positions) >= MAX_TRADES:
        log.info(f"⏸️ Max trades ({MAX_TRADES}) reached — skipping signal")
        return
    
    # Close opposite positions before opening new one
    for pos in ea_positions:
        pos_type = pos.get("type", "")
        if (signal == "BUY" and pos_type == "SELL") or \
           (signal == "SELL" and pos_type == "BUY"):
            log.info(f"🔄 Closing opposite position {pos['ticket']} before reversal")
            close_position(pos["ticket"])
    
    # Calculate SL/TP levels
    if signal == "BUY":
        sl = round(ask - (SL_PIPS * PIP_SIZE), 2)
        tp = round(ask + (TP_PIPS * PIP_SIZE), 2)
        log.info(f"📈 BUY Signal | Ask={ask:.2f} | SL={sl:.2f} | TP={tp:.2f}")
        buy(
            symbol=SYMBOL,
            volume=LOT_SIZE,
            sl=sl,
            tp=tp,
            comment=f"MA_X_EA #{FAST_MA}/{SLOW_MA}",
            magic=MAGIC_NUMBER
        )
        
    elif signal == "SELL":
        sl = round(bid + (SL_PIPS * PIP_SIZE), 2)
        tp = round(bid - (TP_PIPS * PIP_SIZE), 2)
        log.info(f"📉 SELL Signal | Bid={bid:.2f} | SL={sl:.2f} | TP={tp:.2f}")
        sell(
            symbol=SYMBOL,
            volume=LOT_SIZE,
            sl=sl,
            tp=tp,
            comment=f"MA_X_EA #{FAST_MA}/{SLOW_MA}",
            magic=MAGIC_NUMBER
        )
