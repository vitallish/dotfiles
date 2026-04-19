return {
  {
    "L3MON4D3/LuaSnip",
    lazy = false,
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      local ls = require("luasnip")
      local s = ls.snippet
      local t = ls.text_node
      local i = ls.insert_node
      local c = ls.choice_node
      local d = ls.dynamic_node
      local sn = ls.snippet_node
      local fmt = require("luasnip.extras.fmt").fmt

      -- Load all VSCode-style snippets from friendly-snippets
      require("luasnip.loaders.from_vscode").lazy_load()

      -- Custom Quarto snippets
      local quarto_snippets = {

        -- Frontmatter for HTML document: 
        s({ trig = "---", wordTrig = false },
          fmt("---\ntitle: \"{}\"\nauthor: \"{}\"\ndate: today\nformat:\n  html:\n    toc: {}\n    code-fold: {}\n---", {
            d(1, function()
              local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t:r")
              return sn(nil, { i(1, name) })
            end),
            i(2, "West End Statistics, LLC"),
            c(3, { t("true"), t("false") }),
            c(4, { t("true"), t("false") }),
          })
        ),

        -- Basic R chunk: ```r
        s({ trig = "```r", wordTrig = false },
          fmt("```{{r}}\n#| label: {}\n#| include: {}\n\n```", {
            i(1, "chunk-name"),
            c(2, { t("true"), t("false") }),
          })
        ),

        -- R chunk with figure caption: ```rfig
        s({ trig = "```rfig", wordTrig = false },
          fmt("```{{r}}\n#| label: fig-{}\n#| fig-cap: \"{}\"\n#| include: {}\n\n```", {
            i(1, "figname"),
            i(2, "Figure caption"),
            c(3, { t("true"), t("false") }),
          })
        ),

        -- R chunk with table caption: ```rtbl
        s({ trig = "```rtbl", wordTrig = false },
          fmt("```{{r}}\n#| label: {}\n#| tbl-cap: \"{}\"\n#| include: {}\n\n```", {
            i(1, "tbl-"),
            i(2, "Table caption"),
            c(3, { t("true"), t("false") }),
          })
        ),
      }

      ls.add_snippets("quarto", quarto_snippets)
      -- Also available in .qmd files detected as markdown
      ls.add_snippets("markdown", quarto_snippets)
    end,
  },
}
