import Config

config :radio, Radio.Repo,
  url: System.get_env("")
  username: System.get_env("DB_DEV_USERNAME"),
  password: System.get_env("DB_DEV_PASSWORD"),
  hostname: System.get_env(" DB_DEV_HOSTNAME "),
  database: "radio_db",
  socket_options: [:inet6],
  stacktrace: true,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")
