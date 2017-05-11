defmodule PeedyF.WatermarkerBehaviour do
  alias PeedyF.Watermark

  @callback new(text :: String.t) :: Watermark.t
end
