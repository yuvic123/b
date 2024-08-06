local HttpService = game:GetService("HttpService")
local Webhook_URL = "https://discord.com/api/webhooks/1270357764950065214/mU85kRsqukWRyw6iA9e3XNBWvDmTUJx_u6CPNiT2QrC7cZ84zr9zTNAcfKAcDEufEgiZ"

local function sendWebhookMessage()
    local player = game.Players.LocalPlayer
    local playerName = player.DisplayName
    local hardwareId = game:GetService("RbxAnalyticsService"):GetClientId()
    local gameId = game.PlaceId
    local jobId = game.JobId

    -- Fetch game name
    local gameName
    local success, result = pcall(function()
        return game:GetService("MarketplaceService"):GetProductInfo(gameId).Name
    end)
    if success then
        gameName = result
    else
        gameName = "Unknown Game"
        warn("Failed to get game name: " .. tostring(result))
    end

    local message = {
        ["content"] = "",
        ["embeds"] = {{
            ["title"] = "**Your script has been executed!**",
            ["description"] = playerName .. " has executed the script.",
            ["type"] = "rich",
            ["color"] = tonumber(0xffffff),
            ["fields"] = {
                {
                    ["name"] = "Hardware ID:",
                    ["value"] = hardwareId,
                    ["inline"] = true
                },
                {
                    ["name"] = "Game Name:",
                    ["value"] = gameName,
                    ["inline"] = true
                },
                {
                    ["name"] = "Game ID:",
                    ["value"] = gameId,
                    ["inline"] = true
                },
                {
                    ["name"] = "Server ID:",
                    ["value"] = jobId,
                    ["inline"] = true
                },
                {
                    ["name"] = "Join Link:",
                    ["value"] = "roblox://placeID=" .. gameId .. "&gameInstanceId=" .. jobId,
                    ["inline"] = false
                }
            }
        }}
    }

    local jsonData = HttpService:JSONEncode(message)
    local success, result = pcall(function()
        return request({
            Url = Webhook_URL,
            Method = 'POST',
            Headers = {
                ['Content-Type'] = 'application/json'
            },
            Body = jsonData
        })
    end)

    if success then
        print("Webhook message sent successfully!")
    else
        warn("Failed to send webhook message: " .. tostring(result))
    end
end

-- Call the sendWebhookMessage function
sendWebhookMessage()
