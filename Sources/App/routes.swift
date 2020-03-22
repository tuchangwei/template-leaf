{{#fluent}}import Fluent{{/fluent}}
{{#leaf}}import Leaf
{{/leaf}}import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }
    {{#leaf}}
    app.get("hello") { req in
        req.view.render("hello", [
            "name": "Vapor!"
        ])
    }
    {{/leaf}}{{^leaf}}
    app.get("hello") { req -> String in
        return "Hello, world!"
    }
    {{/leaf}}{{#fluent}}
    let todoController = TodoController()
    app.get("todos", use: todoController.index)
    app.post("todos", use: todoController.create)
    app.delete("todos", ":todoID", use: todoController.delete){{/fluent}}
}
