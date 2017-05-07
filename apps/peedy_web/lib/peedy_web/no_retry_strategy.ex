defmodule PeedyWeb.NoRetryStrategy do
  @moduledoc """
  No retry strategy. Used for testing.
  """

  def retry?(_), do: false

  def ms_to_sleep_before(_), do: 0
end
