defmodule PokerEx.TableEvents do
  alias PokerEx.Endpoint
  
  def card_dealt(card) when is_list(card) do
    card = Enum.map(card, fn c -> Map.from_struct(c) end)
    Endpoint.broadcast("players:lobby", "card_dealt", %{card: card})
  end
  
  def card_dealt(card) do
    card = Map.from_struct(card)
    Endpoint.broadcast("players:lobby", "card_deal", %{card: card})
  end
  
  def flop_dealt(flop) do
    cards = Enum.map(flop, fn card -> Map.from_struct(card) end)
    Endpoint.broadcast("players:lobby", "flop_dealt", %{cards: cards})
  end
  
  def pot_update(amount) do
    Endpoint.broadcast("players:lobby", "pot_update", %{amount: amount})
  end
  
  def update_seating(seating) do
    seating = Enum.reduce(seating, %{}, fn {name, seat_num}, acc -> Map.put(acc, name, seat_num) end)
    Endpoint.broadcast!("players:lobby", "update_seating", seating)
  end
  
  def call_amount_update(new_amount) do
    Endpoint.broadcast("players:lobby", "call_amount_update", %{amount: new_amount})
  end
  
  def advance({player, _seat}) do
    Endpoint.broadcast("players:lobby", "advance", %{player: player})
  end
  
  def paid_in_round_update(map) do
    Endpoint.broadcast("players:lobby", "paid_in_round_update", map)
  end
end