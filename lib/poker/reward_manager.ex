defmodule PokerEx.RewardManager do
	alias PokerEx.Player
	
	@type hand_rankings :: [{String.t, pos_integer}]
	@type paid_in :: [{String.t, pos_integer}]
	@type rewards :: [{String.t, pos_integer}]
	
	@spec manage_rewards(hand_rankings, paid_in) :: rewards
	def manage_rewards(hand_rankings, paid_in) do
		_manage(hand_rankings, paid_in, [])
	end
	
	@spec distribute_rewards(rewards) :: :ok
	def distribute_rewards(rewards) do
		Enum.each(rewards, fn {player, amount} -> Player.reward(player, amount) end)
	end
	
	# Used to reward player when all others fold
	@spec reward(Player.t, pos_integer) :: Player.t
	def reward(player, amount) do
		Player.reward(player, amount)
	end
	
	defp _manage([], _, acc), do: acc |> Enum.reverse |> Enum.reject(fn {_, amount} -> amount == 0 end)
	
	defp _manage([{player, _score}|tail], paid_in, acc) do
		{_, paid} = Enum.find(paid_in, fn {name, amount} -> name == player end)
		
		reward = Enum.reduce(paid_in, 0, 
			fn {_name, amount}, acc ->
				if amount <= paid do
					acc + amount
				else
					acc + paid
				end
			end)
		
		paid_in = Enum.map(paid_in, 
			fn {name, amount} -> 
				if amount - paid >= 0 do
					{name, amount - paid} 
				else
					{name, 0}
				end
			end)
			
		_manage(tail, paid_in, [{player, reward}|acc])
	end
end