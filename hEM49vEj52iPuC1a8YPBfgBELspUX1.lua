local Webhook = {}

local HttpService = cloneref(game:GetService("HttpService"))
local Request = request or httprequest or http_request

local DefaultThumbnail = "https://cdn.discordapp.com/attachments/1366160415444439160/1450846645045694474/solix_logo-min_1.png?ex=694405bb&is=6942b43b&hm=084bc5cd54d82d66ac7f79fdd90c412df5071e69d1c70b9a896f707ac44c8606"
local DefaultFooter = "discord.gg/solixhub"
local BaseHeaders = { ["Content-Type"] = "application/json" }

function Webhook.CreateMessage(Properties)
    assert(Properties.Url, "Url required")

    local EmbedIndex = 0
    local Fields = {}
    local HasEmbed = false
    local EmbedData = {}

    local Body = {
        username = Properties.username or "",
        content = Properties.content or "",
        embeds = {}
    }

    local function InternalSend()
        local Success, Response = pcall(HttpService.JSONEncode, HttpService, Body)

        if not Success then
            return { Success = false, Error = Response }
        end

        Success, Response = pcall(Request, {
            Url = Properties.Url,
            Method = "POST",
            Headers = BaseHeaders,
            Body = Response
        })

        return { Success = Success, Response = Response }
    end

    local function InternalSendWithRetry(RetryCount, RetryDelay)
        RetryCount = RetryCount or 3
        RetryDelay = RetryDelay or 2
        
        local LastError = nil
        
        for i = 1, RetryCount do
            local Result = InternalSend()
            
            if Result.Success then
                return Result
            end
            
            LastError = Result.Error or Result.Response
            
            if i < RetryCount then
                task.wait(RetryDelay)
            end
        end
        
        return { Success = false, Error = LastError or "Max retries exceeded" }
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
            assert(Title, "title required")
            assert(Color, "color required")
            assert(Description, "description required")

            EmbedIndex = EmbedIndex + 1
            local Idx = EmbedIndex

            EmbedData = {
                title = Title,
                color = tonumber(Color),
                description = Description,
                fields = {},
                thumbnail = { url = DefaultThumbnail },
                footer = { text = DefaultFooter },
                timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
            }

            Body.embeds[Idx] = EmbedData
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
                    Body.embeds[Idx].color = tonumber(NewColor)
                    return self
                end,

                SetUrl = function(NewUrl)
                    Body.embeds[Idx].url = NewUrl
                    return self
                end,

                SetImage = function(ImageUrl)
                    Body.embeds[Idx].image = { url = ImageUrl }
                    return self
                end,

                SetThumbnail = function(ThumbnailUrl)
                    Body.embeds[Idx].thumbnail = { url = ThumbnailUrl }
                    return self
                end,

                SetFooter = function(FooterText, FooterIcon)
                    Body.embeds[Idx].footer = {
                        text = FooterText or "",
                        icon_url = FooterIcon or ""
                    }
                    return self
                end,

                SetAuthor = function(AuthorName, AuthorUrl, AuthorIcon)
                    Body.embeds[Idx].author = {
                        name = AuthorName or "",
                        url = AuthorUrl or "",
                        icon_url = AuthorIcon or ""
                    }
                    return self
                end,

                AddField = function(Name, Value, Inline)
                    assert(Name, "name required")
                    assert(Value, "value required")
                    
                    table.insert(Body.embeds[Idx].fields, {
                        name = Name,
                        value = Value,
                        inline = Inline or false
                    })
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

        RemoveEmbed = function(EmbedIndex)
            table.remove(Body.embeds, EmbedIndex)
            return self
        end,

        ClearEmbeds = function()
            Body.embeds = {}
            EmbedIndex = 0
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
    local Success, Response = pcall(Request, {
        Url = Url,
        Method = "GET",
        Headers = BaseHeaders
    })
    return Success and Response ~= nil, Response
end

Webhook.DefaultThumbnail = DefaultThumbnail
Webhook.DefaultFooter = DefaultFooter

return Webhook
