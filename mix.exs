defmodule Fizzbuzz.MixProject do
  use Mix.Project

  def project do
    [
      app: :fizzbuzz,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:axon, "~> 0.5.1"},
      {:exla, "~> 0.5.2"},
      {:nx, "~> 0.5.2"},
      {:table_rex, "~> 3.1.1"}
    ]
  end
end
