{{#fluent}}import Fluent
import Fluent{{fluent.db.module}}Driver{{/fluent}}
{{#leaf}}import Leaf
{{/leaf}}import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory)){{#leaf}}
    
    // Configure Leaf
    app.views.use(.leaf)
    if !app.environment.isRelease {
        (app.leaf.cache as? DefaultLeafCache)?.isEnabled = false
    }
    {{/leaf}}{{#fluent}}

    {{#fluent.db.is_postgres}}app.databases.use(.postgres(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
        database: Environment.get("DATABASE_NAME") ?? "vapor_database"
    ), as: .psql){{/fluent.db.is_postgres}}{{#fluent.db.is_mysql}}app.databases.use(.mysql(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
        database: Environment.get("DATABASE_NAME") ?? "vapor_database"
    ), as: .mysql){{/fluent.db.is_mysql}}{{#fluent.db.is_sqlite}}app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite){{/fluent.db.is_sqlite}}

    app.migrations.add(CreateTodo()){{/fluent}}

    // register routes
    try routes(app)
}
