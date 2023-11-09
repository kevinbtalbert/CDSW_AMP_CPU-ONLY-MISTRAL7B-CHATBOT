# CDF to CDSW with Mistral 7B model
Leverage the Mistral 7B model for creating a UI or API derived from your own knowledge base, scraped from your organization's website. This AMP contains the files to host an open source Mistral-based model and an accompanying UI or API. This AMP enables organizations to deploy a custom chatbot, currated to data scraped from a website (or websites) sitemap(s) using CDF (NiFi). 

![](/assets/catalog-entry.png)


## Building your custom knowledge base
To build your own custom knowledge base, you will want to follow the instructions [here](USER_START_HERE/Build_Your_Own_Knowledge_Base_Tools/README.md) in the folder `USER_START_HERE`. There are guides for a Cloudera DataFlow and Pythonic implementation of how to do this. Then, you will want to rerun the `Populate Vector DB` Job to ensure your vector DB has the latest embeddings.

## Two Flavors: UI (Front end) and API
This project allows you to access the context-driven LLM using two flavors: a UI and an API. Both are listed as Applications in CDSW which you can spin up/down as needed. 

### UI (Front end)

This is the default application choice for the AMP. You should be able to access the view through your applications nav. When it starts, you will be able to select the default model (`mistral-7b-instruct`), temperature (a good default is 1), number of tokens (a good default may be 100), topic weight (a domain for the corpus of knowledge to prioritize), and question for the model to process. Defaults will be selected if you choose not to answer these; however a question is required.

### REST API

#### Forming a request to the API
Requests can be formed intra-domain or cross-domain. For cross-domain requests, you'll need to ensure unauthenticated app access is allowed for the POST endpoint to be reachable. Be cognizant of the amount of tokens and temperature you feed into the payload parameters. Most requests for a couple sentences should use around 200 tokens, a paragraph could use upwards of 600-800. 

![](/assets/unauthenticated-access1.png)

Note that if this option does not appear, you may need to update your Administrative security settings to mirror the below, where "Allow applications to be configured with unauthenticated access" is checked:

![](/assets/unauthenticated-access2.png)

For request syntax: 
GET and POST to the ROOT of the CDSW application endpoint (e.g. `https://subdomain.domain.go01-dem.ylcu-atmi.cloudera.site/`)
Successful GET request should indicate the API is up and running:

![](/assets/GET-endpoint.png)

Forming the POST request can be done through Postman or natively in CDSW:

1. Postman

Form the payload/url and body to match the below, and add the header `Content-Type | application/json`

```
{
    "inputs": "What is Cloudera Data Science Workbench?",
    "parameters": {
        "temperature": 1,
        "max_tokens": 100
    }
}
```

![](/assets/postman-setup.png)

Note that in future development, `engine` may also be customized to include more than the Mistral one which comes with the AMP deployment.

2. Pythonic (Available in the 4_app folder as an Jupyter notebook)

## Requirements
#### CDSW Instance Types
This is a CPU/Mem only LLM. NO GPU is required for this AMP.

#### Resource Requirements
This AMP creates the following workloads with resource requirements:
- CDSW Session: `2 CPU, 4GB MEM`
- CDSW Jobs: `4 CPU, 16GB MEM`
- CDSW Application: `4 CPU, 16GB MEM`

#### External Resources
This AMP requires pip packages and models from huggingface. Depending on your CDSW networking setup, you may need to whitelist some domains:
- pypi.python.org
- pypi.org
- pythonhosted.org
- huggingface.co

## Technologies Used
#### Open-Source Models and Utilities
- [all-mpnet-base-v2](https://huggingface.co/sentence-transformers/sentence-transformers/all-mpnet-base-v2/resolve/main/all-mpnet-base-v2.tar.gz)
     - Vector Embeddings Generation Model
- [mistral-7b-instruct-v0.1.Q3_K_L.gguf](https://huggingface.co/TheBloke/Mistral-7B-Instruct-v0.1-GGUF)
   - Instruction-following Large Language Model
- [Hugging Face transformers library](https://pypi.org/project/transformers/)
#### Vector Database
- [Milvus](https://github.com/milvus-io/milvus)
#### Chat Frontend
- [Gradio](https://github.com/gradio-app/gradio)
#### Chat API
- [FastAPI](https://fastapi.tiangolo.com/)

## Deploying on CDSW
There are two ways to launch this prototype on CDSW:

1. **From Prototype Catalog** - Navigate to the Prototype Catalog on a CDSW workspace, select the "CDF to CDSW with Mistal 7B model" tile, click "Launch as Project", click "Configure Project".
2. **As ML Prototype** - In a CDSW workspace, click "New Project", add a Project Name, select "ML Prototype" as the Initial Setup option, copy in the [repo URL](https://github.com/kevinbtalbert/CDSW_AMP_CPU-ONLY-MISTRAL7B-CHATBOT), click "Create Project", click "Configure Project".


## The Fine Print

All the components of the application (knowledge base, context retrieval, prompt enhancement LLM) are running within CDF and CDSW. This application does not call any external model APIs nor require any additional training of an LLM. The knowledge base is generated using the user passed sitemaps in NiFi (CDF) or Python, depending on the user preference.

By configuring and launching this AMP, you will cause TheBloke/Mistral-7B-Instruct-v0.1-GGUF, which is a third party large language model (LLM), to be downloaded and installed into your environment from the third party’s website. Additionally, you will be downloading sentence-transformers/all-mpnet-base-v2, which is the embedding model used in this project. Please see https://huggingface.co/TheBloke/Mistral-7B-Instruct-v0.1-GGUF and https://huggingface.co/sentence-transformers/all-mpnet-base-v2 for more information about the LLM and embedding model, including the applicable license terms.  If you do not wish to download and install TheBloke/Mistral-7B-Instruct-v0.1-GGUF and sentence-transformers/all-mpnet-base-v2, do not deploy this repository.  By deploying this repository, you acknowledge the foregoing statement and agree that Cloudera is not responsible or liable in any way for TheBloke/Mistral-7B-Instruct-v0.1-GGUF and sentence-transformers/all-mpnet-base-v2. Author: Cloudera Inc.
