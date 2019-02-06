defmodule ExAbci.MixProject do
  use Mix.Project

  @version File.cwd!() |> Path.join("version") |> File.read!() |> String.trim()
  @elixir_version File.cwd!() |> Path.join(".elixir_version") |> File.read!() |> String.trim()
  @otp_version File.cwd!() |> Path.join(".otp_version") |> File.read!() |> String.trim()

  def get_version, do: @version
  def get_elixir_version, do: @elixir_version
  def get_otp_version, do: @otp_version

  def project do
    [
      app: :ex_abci,
      version: @version,
      elixir: @elixir_version,
      description: description(),
      package: package(),
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      # Docs
      name: "ExAbci",
      source_url: "https://github.com/arcblock/ex_abci",
      homepage_url: "https://github.com/arcblock/ex_abci",
      docs: [
        main: "ExAbci",
        extras: ["README.md"]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(:dev), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # Normal depedencies
      {:ex_abci_proto, "~> 0.7.6"},

      # dev & test
      {:credo, "~> 0.8", only: [:dev, :test]},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.19", only: [:dev, :test]},
      {:pre_commit_hook, "~> 1.2", only: [:dev, :test]}
    ]
  end

  defp description do
    """
    [Tendermint ABCI spec](https://github.com/tendermint/tendermint/wiki/Application-Developers) implementation. Inspired by [abci_server](https://github.com/KrzysiekJ/abci_server) and [js-abci](https://github.com/tendermint/js-abci).
    """
  end

  defp package do
    [
      files: [
        "config",
        "lib",
        "mix.exs",
        "README*",
        "version",
        ".elixir_version",
        ".otp_version"
      ],
      licenses: ["Apache 2.0"],
      maintainers: ["tyr.chen@gmail.com"],
      links: %{
        "GitHub" => "https://github.com/arcblock/ex_abci",
        "Docs" => "https://hexdocs.pm/ex_abci"
      }
    ]
  end
end
