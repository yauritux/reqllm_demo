defmodule ReqllmDemo.MixProject do
  use Mix.Project

  def project do
    [
      app: :reqllm_demo,
      version: "0.1.0",
      elixir: "~> 1.20",
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
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:dotenvy, "~> 1.1"},
      {:req_llm, "~> 1.17"},
      {:abacus, "~> 2.2"},
      {:ex_doc, "~> 0.12"}
    ]
  end
end
