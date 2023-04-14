defmodule Fizzbuzz do
  @moduledoc """
  Documentation for `Fizzbuzz`.
  """

  require Axon
  require Nx

  # @labels ~w[fizz buzz fizzbuzz]

  def features(n) do
    [rem(n, 3), rem(n, 5), rem(n, 15)]
  end

  def train_data do
    for n <- 1..100 do
      Nx.tensor(features(n))
      |> Nx.reshape({1, 3})
    end
  end

  def test_data do
    for n <- 1..15 do
      features(n)
    end
    |> Nx.tensor()
  end

  def model do
    Axon.input("model", shape: {nil, 3})
    |> Axon.dense(10, activation: :tanh)
    |> Axon.dense(4, activation: :softmax)
  end

  def puts_model do
    model()
    |> Axon.Display.as_table(Nx.template({1, 3}, :s64))
    |> IO.puts()
  end

  def targets do
    for n <- 1..1000 do
      Nx.tensor([categories(n)])
    end
  end

  defp categories(n) do
    cond do
      rem(n, 15) == 0 -> [0, 0, 1, 0]
      rem(n, 3) == 0 -> [1, 0, 0, 0]
      rem(n, 5) == 0 -> [0, 1, 0, 0]
      true -> [0, 0, 0, 1]
    end
  end

  def train(model, epochs \\ 5) do
    optimizer = Axon.Optimizers.adamw(0.005)
    loss = :categorical_cross_entropy

    train = Fizzbuzz.train_data()
    targets = Fizzbuzz.targets()

    model
    |> Axon.Loop.trainer(loss, optimizer)
    |> Axon.Loop.run(train, targets, epochs: epochs, compiler: EXLA)
    # |> Axon.Loop.run(train, targets, epochs: epochs, compiler: EXLA)
  end
end
