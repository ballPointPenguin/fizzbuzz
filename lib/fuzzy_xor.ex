defmodule FuzzyXor do
  @moduledoc """
  Documentation for `FuzzyXor`.
  """

  require Axon
  require Nx

  def fuzzy_xor(a, b, threshold) do
    if abs(a - b) > threshold, do: 1, else: 0
  end

  def simple_xor({a, b}), do: [a, b, Bitwise.bxor(a, b)]

  def rand_tuples(n \\ 100) do
    Enum.map(1..n, fn _ ->
      [:rand.uniform(), :rand.uniform()]
    end)
  end


  def features([a, b]) do
    [fuzzy_xor(a, b, 0.2)]
  end

  def chunk_features(list_of_pairs), do: Enum.map(list_of_pairs, &features/1)

  def train_data do
    rand_tuples(1000)
    |> Enum.chunk_every(20)
    |> Enum.map(fn input -> {
      Nx.tensor(input),
      Nx.tensor(chunk_features(input))
    } end)
  end

  def model do
    Axon.input("model", shape: {nil, 2})
    |> Axon.dense(10, activation: :relu)
    |> Axon.dense(10, activation: :relu)
    |> Axon.dense(1, activation: :sigmoid)
  end

  def puts_model do
    model()
    |> Axon.Display.as_table(Nx.template({1, 3}, :s64))
    |> IO.puts()
  end

  def train(epochs \\ 5) do
    # Nx.global_default_backend({EXLA.Backend, client: :cuda})

    model = FuzzyXor.model()
    optimizer = Axon.Optimizers.adamw(0.005)
    loss = :binary_cross_entropy
    train = FuzzyXor.train_data()

    model
    |> Axon.Loop.trainer(loss, optimizer)
    |> Axon.Loop.run(train, %{}, epochs: epochs, compiler: EXLA)
  end
end
