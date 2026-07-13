defmodule AIChat do
  @moduledoc """
  Documentation for `AIChat`.
  """

  @default_model %{provider: :ollama, id: "llama3.2"}

  @type create_opts :: [
    context: String.t(),
    result: String.t(),
    explain: String.t(),
    audience: String.t(),
    tone: String.t(),
    edit: String.t(),
    model: map()
  ]

  def ask_create(user_request, opts \\ [])
      when is_binary(user_request) and is_list(opts) do
    model_spec = Keyword.get(opts, :model, @default_model)
    messages = build_create_messages(user_request, opts)

    model = ReqLLM.model!(model_spec)

    case ReqLLM.generate_text(model, messages) do
      {:ok, response} -> {:ok, ReqLLM.Response.text(response)}
      {:error, reason} -> {:error, reason}
    end
  end

  def build_create_messages(user_request, opts \\ [])
      when is_binary(user_request) and is_list(opts) do
    context = Keyword.get(opts, :context, "You are an expert assistant.")
    result = Keyword.get(opts, :result, "Provide a clear, actionable output.")
    explain = Keyword.get(opts, :explain, "Briefly explain the reasoning, then answer.")
    audience = Keyword.get(opts, :audience, "A software engineer familiar with Elixir.")
    tone = Keyword.get(opts, :tone, "Concise, friendly, and direct.")
    edit = Keyword.get(opts, :edit, "Do a quick self-check and refine for clarity.")

    [
      %{
        role: "system",
        content: """
        You are role-playing using the CREATE framework.

        CREATE:
        - Context: #{context}
        - Result: #{result}
        - Explain: #{explain}
        - Audience: #{audience}
        - Tone: #{tone}
        - Edit: #{edit}

        Always follow CREATE. Ask at most 1 clarification question if needed.
        """
      },
      %{
        role: "user",
        content: user_request
      }
    ]
  end

  defp stream(prompt) do
    Keyword.get([], :model, @default_model)
    |> ReqLLM.model!
    |> ReqLLM.stream_text(prompt)
  end

  @doc """
    Returns a response to the prompt.

  # Examples

      iex> AIChat.ask("Tell me a joke in Elixir!")
  """
  def ask(prompt) when is_binary(prompt) do
    case stream(prompt) do
      {:ok, stream_response} ->
        stream_response
        |> ReqLLM.StreamResponse.tokens()
        |> Enum.each(&IO.write/1)
      {:error, reason} ->
        {:error, reason}
    end
  end
end
