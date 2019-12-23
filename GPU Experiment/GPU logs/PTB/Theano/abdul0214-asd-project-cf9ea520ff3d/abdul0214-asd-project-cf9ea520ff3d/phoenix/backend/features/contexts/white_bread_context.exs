defmodule WhiteBreadContext do
  use WhiteBread.Context


  given_ ~r/^My email is "(?<argument_one>[^"]+)" and password is "(?<argument_two>[^"]+)"$/,
         fn state, %{argument_one: _argument_one,argument_two: _argument_two} ->
           {:ok, state}
         end

  when_ ~r/^I submit the registration request$/, fn state ->
    {:ok, state}
  end

  then_ ~r/^I should receive a token$/, fn state ->
    {:ok, state}
  end

  given_ ~r/^the following users exist$/, fn state ->
    {:ok, state}
  end

  when_ ~r/^I submit the login request$/, fn state ->
    {:ok, state}
  end

end
