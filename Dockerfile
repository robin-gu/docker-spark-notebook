# Choose your desired base image
FROM jupyter/all-spark-notebook:latest

# name your environment and choose python 3.x version
ARG conda_env=python36
ARG py_ver=3.6

# you can add additional libraries you want conda to install by listing them below the first line and ending with "&& \"
RUN conda create --quiet --yes -p $CONDA_DIR/envs/$conda_env python=$py_ver ipython ipykernel && \
    conda clean --all -f -y

# alternatively, you can comment out the lines above and uncomment those below
# if you'd prefer to use a YAML file present in the docker build context

# COPY --chown=${NB_UID}:${NB_GID} environment.yml /home/$NB_USER/tmp/
# RUN cd /home/$NB_USER/tmp/ && \
#     conda env create -p $CONDA_DIR/envs/$conda_env -f environment.yml && \
#     conda clean --all -f -y
ADD https://github.com/tencentyun/hadoop-cos/releases/download/v5.9.3/hadoop-cos-3.1.0-5.9.3.jar /usr/local/spark/jars/hadoop-cos-3.1.0-5.9.3.jar
ADD https://github.com/tencentyun/hadoop-cos/releases/download/v5.9.3/cos_api-bundle-5.6.35.jar /usr/local/spark/jars/cos_api-bundle-5.6.35.jar 
USER root
RUN chmod a+r  /usr/local/spark/jars/cos_api-bundle-5.6.35.jar && \
    chmod a+r  /usr/local/spark/jars/hadoop-cos-3.1.0-5.9.3.jar
USER $NB_USER
# create Python 3.x environment and link it to jupyter
RUN $CONDA_DIR/envs/${conda_env}/bin/python -m ipykernel install --user --name=${conda_env} && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# any additional pip installs can be added by uncommenting the following line
# RUN $CONDA_DIR/envs/${conda_env}/bin/pip install 

# prepend conda environment to path
ENV PATH $CONDA_DIR/envs/${conda_env}/bin:$PATH

# if you want this environment to be the default one, uncomment the following line:
# ENV CONDA_DEFAULT_ENV ${conda_env}