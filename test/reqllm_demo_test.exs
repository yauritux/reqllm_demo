require IEx

{:ok ,response} = ReqLLM.generate_text("ollama:llama3.2", "Hello!")

IEx.pry()

IO.puts(ReqLLM.Response.text(response))

model = ReqLLM.model!(%{id: "llama3.2", provider: "ollama"})

{:ok, stream_response} = ReqLLM.stream_text(model, "Write a poetry about programming.")

stream_response
  |> ReqLLM.StreamResponse.tokens()
  |> Enum.each(&IO.write/1)

IEx.pry()

{:ok, response2} = ReqLLM.generate_text(
  model,
  [
    ReqLLM.Context.system("You are a helpful coding assistant."),
    ReqLLM.Context.user("Explain recursion in Elixir")
  ],
  temperature: 0.7,
  max_tokens: 200
)

IEx.pry()
