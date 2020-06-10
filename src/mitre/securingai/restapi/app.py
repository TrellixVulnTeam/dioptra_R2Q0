import uuid
from typing import Any, Callable, List, Optional

import structlog
from flask import Flask, jsonify
from flask_injector import FlaskInjector
from flask_restx import Api

LOGGER = structlog.get_logger()


def create_app(env: Optional[str] = None, inject_dependencies: bool = True):
    from .config import config_by_name
    from .dependencies import bind_dependencies, register_providers
    from .routes import register_routes

    if env is None:
        env = "test"

    app: Flask = Flask(__name__)
    app.config.from_object(config_by_name[env])
    api: Api = Api(
        app, title="Securing AI Machine Learning Model Endpoint", version="0.0.0"
    )
    modules: List[Callable[..., Any]] = [bind_dependencies]

    register_routes(api, app)
    register_providers(modules)

    @app.route("/health")
    def health():
        log = LOGGER.new(request_id=str(uuid.uuid4()))  # noqa: F841
        return jsonify("healthy")

    if not inject_dependencies:
        return app

    FlaskInjector(app=app, modules=modules)

    return app
