defmodule Fxex do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Define workers and child supervisors to be supervised
      # worker(Fxex.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Fxex.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def rates do
    url = 'http://openexchangerates.org/api/latest.json?app_id=2bcca613e8034f2cbd416a027258d599'
    :inets.start :httpd
    request = :httpc.request(:get, {url, []}, [], [])
    {_,body} = request
    {_,_,list} = body
    str = List.to_string(list)
    dst = JSX.decode(str)
    {:ok, hsh} = dst
    hsh["rates"]
  end

  def usd(curr) do
    exchange_rates = Fxex.rates
    exchange_rates[curr]
  end

  # def parse_gdp_table do
  #   url = 'https://en.wikipedia.org/wiki/List_of_countries_by_GDP_(nominal)'
  #   :inets.start :httpd
  #   req = :httpc.request(:get, {url,[]},[],[])
  #   {:ok, body} = req
  #   {_,_,list} = body
  #   list
  # end
end
