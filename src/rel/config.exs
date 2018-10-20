
Path.join(["rel", "plugins", "*.exs"])
|> Path.wildcard()
|> Enum.map(&Code.eval_file(&1))

use Mix.Releases.Config,
    default_release: :default,
    default_environment: Mix.env()


environment :dev do
  set dev_mode: true
  set include_erts: false
  set cookie: :"arcblock"
end

environment :staging do
  set include_erts: true
  set include_src: false
  set cookie: :"F!!O{%,rp]p1^}c44yFu6NVs^L0m5lB8?H!USeCkLx>(^DPBNPinYXU/l5!|@S5Q"
end

environment :prod do
  set include_erts: true
  set include_src: false
  set cookie: :"&CKitUm*!T%K}XTR6tBo3A:Z/XcX5k<n7dNju?4%(Q/Umfn872[*kr}):b$%y*:d"
end

# You may define one or more releases in this file.
# If you have not set a default release, or selected one
# when running `mix release`, the first release in the file
# will be used by default

release :src do
  set version: "0.1.0"
  set applications: [
    :runtime_tools,
  ]
end
