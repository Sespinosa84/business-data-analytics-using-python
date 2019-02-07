FROM jupyter/datascience-notebook:83ed2c63671f

USER root
RUN apt-get update && apt-get install -y graphviz
ENV PATH /graphviz:$PATH

#Set the working directory
WORKDIR /home/jovyan/

# Modules
COPY requirements.txt /home/jovyan/requirements.txt
RUN pip install -r /home/jovyan/requirements.txt

# Add files
COPY notebooks /home/jovyan/notebooks
COPY data /home/jovyan/data
COPY solutions /home/jovyan/solutions

# Allow user to write to directory
USER root
RUN chown -R $NB_USER /home/jovyan \
    && chmod -R 774 /home/jovyan
USER $NB_USER

# Expose the notebook port
EXPOSE 8888

# Start the notebook server
CMD jupyter notebook --no-browser --port 8888 --ip=0.0.0.0 --NotebookApp.token='' --NotebookApp.disable_check_xsrf=True --NotebookApp.iopub_data_rate_limit=1.0e10
