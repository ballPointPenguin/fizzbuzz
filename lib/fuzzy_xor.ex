defmodule FuzzyXor do
  @moduledoc """
  Documentation for `FuzzyXor`.
  """

  require Axon
  require Nx

  def features({a, b}), do: [a, b, Bitwise.bxor(a, b)]

  def train_data do
  end
end
