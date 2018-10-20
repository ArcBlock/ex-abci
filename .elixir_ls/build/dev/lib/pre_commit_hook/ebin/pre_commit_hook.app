{application,pre_commit_hook,
             [{applications,[kernel,stdlib,elixir,logger]},
              {description,"PreCommitHook provides hook in \".git/hooks/pre-commit\" which helps you to build elixir project with these checks:\n\n* code must compile\n* code must pass basic linting (.credo.exs will be copied if it doesn't exist)\n* code must pass test\n* code must pass docs generation.\n"},
              {modules,['Elixir.Mix.Tasks.TestAll','Elixir.PreCommitHook',
                        'Elixir.PreCommitHook.Util']},
              {registered,[]},
              {vsn,"1.2.0"},
              {extra_applications,[logger]}]}.
