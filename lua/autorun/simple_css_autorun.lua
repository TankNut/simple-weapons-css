if SERVER then
	resource.AddWorkshop("2821865508")
end

module("simple_weapons.Convars.css", package.seeall)

FlashRange = CreateConVar("simple_css_flashbang_radius", 1500, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "The max radius that flashbangs affect people in.", 0)
FlashSeverity = CreateConVar("simple_css_flashbang_severity", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "The severity of the flashbang's blind effect, this affects both the visual and audio effects.", 0)
