defmodule AIChat do
  @moduledoc """
  Documentation for `AIChat`.
  """

  @default_model %{provider: :ollama, id: "llama3.2"}

  defp stream(prompt) when is_binary(prompt) do
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
