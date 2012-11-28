RBNF.define :EBNF_WS do
  RBNF[' '] / "\t" / "\n" + RBNF.EBNF_WS.rep
end
RBNF.define :EBNF_NWS do
  "bcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_-".split(//).inject(RBNF[?a],:/) + +RBNF.EBNF_NWS
end

RBNF.define :EBNF_ID do
  RBNF.EBNF_NWS.group / (RBNF.EBNF_NWS + +(RBNF.EBNF_WS / RBNF.EBNF_NWS) + RBNF.EBNF_NWS)
end

RBNF.define :EBNF_TERM do
  RBNF[?"] + -RBNF.EBNF_WS + RBNF.EBNF_ID + -RBNF.EBNF_WS + ?"
end

RBNF.define :EBNF_ASSIGN do
  RBNF.EBNF_ID + RBNF.EBNF_WS + ?= + RBNF.EBNF_WS
end

RBNF.define :EBNF_ATOM do
  RBNF.EBNF_TERM / RBNF.EBNF_ID
end

RBNF.define :EBNF_BIN_OP do
  RBNF[?|] / ','
end


RBNF.define :EBNF_BIN do
  RBNF.EBNF_ATOM + RBNF.EBNF_WS + RBNF.EBNF_BIN_OP + RBNF.EBNF_WS + RBNF.EBNF_ATOM
end


RBNF.define :EBNF do

end
