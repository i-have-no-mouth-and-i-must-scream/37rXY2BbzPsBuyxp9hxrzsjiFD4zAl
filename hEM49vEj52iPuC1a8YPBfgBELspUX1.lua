local Webhook = {}

local HttpService = (cloneref and cloneref(game:GetService("HttpService"))) or game:GetService("HttpService")
local Request = request or httprequest or http_request

local BaseHeaders = { ["Content-Type"] = "application/json" }

local function ColorToDecimal(Color)
    if not Color then return nil end
    if type(Color) == "number" then return Color end
    if typeof(Color) == "Color3" then
        local r, g, b = Color.R * 255, Color.G * 255, Color.B * 255
        return bit32.lshift(math.floor(r), 16) + bit32.lshift(math.floor(g), 8) + math.floor(b)
    end
    return nil
end

function Webhook.CreateMessage(Properties)
    assert(Properties.Url, "Url required")

    local EmbedIndex = 0
    local HasEmbed = false

    local Body = {
        username = Properties.username or "",
        content = Properties.content or "",
        embeds = {}
    }

    local function InternalSend()
        local Encoded = HttpService:JSONEncode(Body)

        if not Request then
            return { Success = false, Error = "No request function" }
        end

        local Response = Request({
            Url = Properties.Url,
            Method = "POST",
            Headers = BaseHeaders,
            Body = Encoded
        })

        if Response.Success then
            return { Success = true }
        else
            return { Success = false, Error = Response.Body }
        end
    end

    local function InternalSendWithRetry(RetryCount, RetryDelay)
        RetryCount = RetryCount or 3
        RetryDelay = RetryDelay or 2
        
        for i = 1, RetryCount do
            local Result = InternalSend()
            
            if Result.Success then
                return Result
            end
            
            if i < RetryCount then
                task.wait(RetryDelay)
            end
        end
        
        return { Success = false, Error = "Max retries exceeded" }
    end

    return {
        SetUsername = function(Username)
            Body.username = Username or ""
            return self
        end,

        SetContent = function(Content)
            Body.content = Content or ""
            return self
        end,

        SetAvatar = function(AvatarUrl)
            Body.avatar_url = AvatarUrl or ""
            return self
        end,

        AddEmbed = function(Title, Color, Description)
            EmbedIndex = EmbedIndex + 1
            local Idx = EmbedIndex

            Body.embeds[Idx] = {
                title = Title,
                color = ColorToDecimal(Color),
                description = Description,
                fields = {},
                thumbnail = {
                    url = "https://cdn.discordapp.com/attachments/1366160415444439160/1450846645045694474/solix_logo-min_1.png?ex=694405bb&is=6942b43b&hm=084bc5cd54d82d66ac7f79fdd90c412df5071e69d1c70b9a896f707ac44c8606"
                },
                footer = {
                    text = "https://solixhub.com"
                },
                timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
            }

            HasEmbed = true

            return {
                SetTitle = function(NewTitle)
                    Body.embeds[Idx].title = NewTitle
                    return self
                end,

                SetDescription = function(NewDescription)
                    Body.embeds[Idx].description = NewDescription
                    return self
                end,

                SetColor = function(NewColor)
                    Body.embeds[Idx].color = ColorToDecimal(NewColor)
                    return self
                end,

                SetUrl = function(NewUrl)
                    Body.embeds[Idx].url = NewUrl
                    return self
                end,

                SetImage = function(ImageUrl)
                    if ImageUrl then
                        Body.embeds[Idx].image = { url = ImageUrl }
                    end
                    return self
                end,

                SetThumbnail = function(ThumbnailUrl)
                    if ThumbnailUrl then
                        Body.embeds[Idx].thumbnail = { url = ThumbnailUrl }
                    end
                    return self
                end,

                SetFooter = function(FooterText, FooterIcon)
                    Body.embeds[Idx].footer = {
                        text = FooterText or "",
                        icon_url = FooterIcon
                    }
                    return self
                end,

                SetAuthor = function(AuthorName, AuthorUrl, AuthorIcon)
                    Body.embeds[Idx].author = {
                        name = AuthorName or "",
                        url = AuthorUrl,
                        icon_url = AuthorIcon
                    }
                    return self
                end,

                SetTimestamp = function(Timestamp)
                    Body.embeds[Idx].timestamp = Timestamp
                    return self
                end,

                AddField = function(Name, Value, Inline)
                    if Name and Value then
                        table.insert(Body.embeds[Idx].fields, {
                            name = tostring(Name),
                            value = tostring(Value),
                            inline = (Inline == true)
                        })
                    end
                    return self
                end,

                ClearFields = function()
                    Body.embeds[Idx].fields = {}
                    return self
                end,

                RemoveField = function(FieldIndex)
                    table.remove(Body.embeds[Idx].fields, FieldIndex)
                    return self
                end
            }
        end,

        RemoveEmbed = function(EmbedIndexToRemove)
            if EmbedIndexToRemove then
                table.remove(Body.embeds, EmbedIndexToRemove)
            end
            return self
        end,

        ClearEmbeds = function()
            Body.embeds = {}
            EmbedIndex = 0
            HasEmbed = false
            return self
        end,

        Send = function()
            if not HasEmbed and Body.content == "" then
                return { Success = false, Error = "Message must have either content or at least one embed" }
            end
            return InternalSend()
        end,

        SendWithRetry = function(RetryCount, RetryDelay)
            if not HasEmbed and Body.content == "" then
                return { Success = false, Error = "Message must have either content or at least one embed" }
            end
            return InternalSendWithRetry(RetryCount, RetryDelay)
        end,

        GetBody = function()
            return Body
        end,

        GetEmbedCount = function()
            return EmbedIndex
        end
    }
end

function Webhook.EncodeJson(Table)
    local Success, Result = pcall(HttpService.JSONEncode, HttpService, Table)
    return Success and Result or nil, Success and nil or Result
end

function Webhook.DecodeJson(String)
    local Success, Result = pcall(HttpService.JSONDecode, HttpService, String)
    return Success and Result or nil, Success and nil or Result
end

function Webhook.TestConnection(Url)
    if not Request then
        return false, { Success = false, Body = "No request function" }
    end
    local Response = Request({
        Url = Url,
        Method = "GET",
        Headers = BaseHeaders
    })
    return Response.Success ~= nil, Response
end

function Webhook.IsAvailable()
    return Request ~= nil
end

return Webhook
