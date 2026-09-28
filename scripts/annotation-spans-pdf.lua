-- Map selected semantic span classes to LaTeX macros for PDF/LaTeX output.
-- Other formats keep the original span classes for CSS-based rendering.

local is_latex_output = FORMAT:match("latex") or FORMAT:match("pdf")

if not is_latex_output then
  return {}
end

local class_to_macro = {
  ["ann-premise"] = "annpremise",
  ["ann-conclusion"] = "annconclusion",
  ["ann-key"] = "annkey",
}

function Span(el)
  for _, class_name in ipairs(el.classes) do
    local macro_name = class_to_macro[class_name]
    if macro_name then
      local wrapped = {
        pandoc.RawInline("latex", "\\" .. macro_name .. "{"),
      }
      for _, inline in ipairs(el.content) do
        wrapped[#wrapped + 1] = inline
      end
      wrapped[#wrapped + 1] = pandoc.RawInline("latex", "}")
      return wrapped
    end
  end

  return nil
end
