import pandas as pd
from flask import Flask, jsonify, request
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

data = pd.read_csv(
    "dataset/relatorio_cadop.csv",
    sep=";",
)


@app.route("/", methods=["GET"])
def home():
    return jsonify({"message": "Hello, World!"})


@app.route("/records", methods=["GET"])
def get_all_records():
    page = int(request.args.get("page", 1))
    limit = int(request.args.get("limit", 9))

    query_params = request.args.to_dict()

    filtered_data = data

    for key, value in query_params.items():
        if key in data.columns:
            filtered_data = data[
                data[key].astype(str).str.contains(value, case=False, na=False)
            ]
    start = (page - 1) * limit
    end = page * limit
    paginated_data = filtered_data[start:end]

    total_records = len(filtered_data)
    total_pages = (total_records // limit) + (1 if total_records % limit > 0 else 0)

    return {
        "data": paginated_data.to_json(orient="records"),
        "total_records": total_records,
        "total_pages": total_pages,
        "current_page": page,
        "per_page": limit,
    }


if __name__ == "__main__":
    app.run(debug=True)
