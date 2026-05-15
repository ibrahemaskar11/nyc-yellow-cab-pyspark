# NYC Yellow Cab Trip Analysis — PySpark

**Student:** Ibrahim Askar | **ID:** 0001159181  
**Course:** Big Data Analytics & Text Mining — University of Bologna

Analysis of ~6 million NYC Yellow Cab trips (Jan–Feb 2024) using Apache Spark. Covers EDA, clustering, and supervised ML entirely inside PySpark.

---

## Notebooks

| Notebook | Description | Platform |
|---|---|---|
| `course_notebook.ipynb` | EDA · K-Means · Random Forest · Logistic Regression | Course VM (4 GB RAM) |
| `project_work_notebook.ipynb` | GBT Regression · PCA · k-NN (exact + LSH) | Course VM (4 GB RAM) |

Both notebooks are **fully executed** — all outputs, metrics, and plots are already embedded. You can read them directly on GitHub without running anything.

---

## Dataset

Downloaded automatically by the notebooks at runtime — no manual setup needed.

- **Source:** NYC TLC public dataset (Parquet)
- **Files:** `yellow_tripdata_2024-01.parquet` (~48 MB) and `yellow_tripdata_2024-02.parquet` (~49 MB)
- **Rows:** 5,972,150 combined

---

## Reproducing the Results

### Option A — Vagrant VM (recommended, exact environment)

Requires [VirtualBox](https://www.virtualbox.org/) and [Vagrant](https://www.vagrantup.com/).

```bash
git clone https://github.com/ibrahemaskar11/nyc-yellow-cab-pyspark.git
cd nyc-yellow-cab-pyspark
vagrant up          # first run takes ~10 min (downloads Ubuntu box + provisions)
vagrant ssh
```

Inside the VM:

```bash
cd /vagrant
jupyter notebook --no-browser --ip=0.0.0.0 --port=8888
```

Open **http://localhost:8888** in your browser, then open and run each notebook from top to bottom.

**VM specs:** Ubuntu 22.04, OpenJDK 11, 4 GB RAM, 2 vCPUs. The `bootstrap.sh` provisioner installs Java and Jupyter automatically. PySpark 3.5.3 is installed by the first cell of each notebook.

> **Runtime:** `course_notebook.ipynb` takes ~30 min end-to-end. `project_work_notebook.ipynb` takes ~90 min (GBT and two Random Forest runs are the slow steps).

### Option B — Local Python environment

Requires Python 3.10+, pip, and Java 11 (OpenJDK).

```bash
git clone https://github.com/ibrahemaskar11/nyc-yellow-cab-pyspark.git
cd nyc-yellow-cab-pyspark
pip install pyspark==3.5.3 findspark jupyter matplotlib pandas seaborn numpy scikit-learn
jupyter notebook
```

Open each notebook and run all cells. Make sure `JAVA_HOME` points to a valid JDK 11 install.

---

## Algorithms

| Algorithm | Task | Notebook |
|---|---|---|
| K-Means (k=2) | Trip pattern clustering | course |
| Random Forest (100 trees) | High-tip prediction (AUC 0.697) | course |
| Logistic Regression | Baseline classifier (AUC 0.668) | course |
| GBT Regression (50 iters) | Fare amount prediction (R²=0.95) | project |
| PCA | Dimensionality reduction + RF comparison | project |
| k-NN (sklearn + LSH) | Classification + scalability analysis | project |

---

## Key Results

| Model | Metric | Value |
|---|---|---|
| Random Forest | AUC-ROC | 0.6966 |
| Random Forest | Accuracy | 80.51% |
| Logistic Regression | AUC-ROC | 0.6683 |
| GBT Regression | R² | 0.9500 |
| GBT Regression | RMSE | $3.66 |
| Linear Regression | R² | 0.7963 |
| K-Means (k=2) | Silhouette | 0.6436 |
