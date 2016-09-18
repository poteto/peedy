defmodule Watermarker.WatermarkerBehaviour do
  alias Watermarker.Watermark

  @callback new(text :: String.t) :: Watermark.t
end
