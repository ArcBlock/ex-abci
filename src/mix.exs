defmodule ChangeMe.MixProject do
  use Mix.Project

  @version File.cwd!() |> Path.join("../version") |> File.read!() |> String.trim()
  @elixir_version File.cwd!() |> Path.join(".elixir_version") |> File.read!() |> String.trim()
  def project do
    [
      apps_path: "apps",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def get_version, do: @version
  def get_elixir_version, do: @elixir_version

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the apps folder.
  #
  # Run "mix help deps" for examples and options.
  defp deps do
    [
      # Normal depedencies
      {:jason, "~> 1.0"},

      # utility tools for error logs and metrics
      {:statix, ">= 0.0.0"},
      {:logger_sentry, "~> 0.1.5"},
      {:recon, "~> 2.3.2"},
      {:recon_ex, "~> 0.9.1"},
      {:sentry, "~> 6.2.0"},

      # deployment
      {:distillery, "~> 1.5", runtime: false},

      # dev & test
      {:benchee, "~> 0.13.0", only: [:dev, :test]},
      {:credo, "~> 0.8", only: [:dev, :test]},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.18", only: [:dev, :test]},
      {:excheck, "~> 0.5", only: :test},
      {:mox, "~> 0.3", only: :test},
      {:pre_commit_hook, "~> 1.2", only: [:dev, :test]},
      {:triq, github: "triqng/triq", only: :test}
    ]
  end
end
