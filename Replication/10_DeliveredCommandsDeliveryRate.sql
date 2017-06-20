SELECT agent_id,MAX(total_delivered_commands) AS DeliveredCommands FROM dbo.MSdistribution_history
GROUP BY agent_id
ORDER BY MAX(total_delivered_commands) DESC

SELECT current_delivery_rate,* FROM dbo.MSdistribution_history
--WHERE agent_id IN (23,26)
ORDER BY time DESC