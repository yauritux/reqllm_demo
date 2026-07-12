defmodule AIChat do
  @moduledoc """
  Documentation for `AIChat`.
  """

  @doc """
    Returns a response to the prompt.

  # Examples

      iex> AIChat.ask("Tell me a joke in Elixir!")
  """
  def ask(prompt) when is_bitstring(prompt) do
    model = ReqLLM.model!(%{id: "llama3.2", provider: "ollama"})
    case ReqLLM.stream_text(model, prompt) do
      {:ok, stream_response} ->
        IO.puts("🤖 Thinking...")
        stream_response
        |> ReqLLM.StreamResponse.tokens()
        |> Enum.each(&IO.write/1)
      {:error, reason} ->
        IO.puts("Error: #{inspect(reason)}")
    end
  end
end
