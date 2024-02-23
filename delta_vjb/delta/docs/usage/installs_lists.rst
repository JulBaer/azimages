Successful installs
====================

Here we maintain a list of successful installation
library lists for debugging purposes.

These environments installed successfully, detected
the machine's GPU, and passed
all our tests with pytest.

If you had to tweak library versions, or even if you
had a smooth installation process, feel free to 
share your environment list with us via gitlab's issues 
so we can list it here.

.. contents:: Table of Contents
    :depth: 3

.. highlight:: none

Linux installs
==============


Linux (EL7) conda yml install, TF 2.4
--------------------------------------

Install date Summer 2021

`conda list` output::

	# packages in environment at /projectnb/dunlop/DeLTA_env_default/.conda/envs/delta_env:
	#
	# Name                    Version                   Build  Channel
	_libgcc_mutex             0.1                 conda_forge    conda-forge
	_openmp_mutex             4.5                       1_gnu    conda-forge
	_tflow_select             2.1.0                 gpu.conda
	absl-py                   0.13.0             pyhd8ed1ab_0    conda-forge
	aiohttp                   3.7.4.post0      py37h5e8e339_0    conda-forge
	alabaster                 0.7.12                     py_0    conda-forge
	alsa-lib                  1.2.3                h516909a_0    conda-forge
	appdirs                   1.4.4              pyh9f0ad1d_0    conda-forge
	argcomplete               1.12.3             pyhd8ed1ab_2    conda-forge
	argh                      0.26.2          pyh9f0ad1d_1002    conda-forge
	arrow                     1.1.1              pyhd8ed1ab_0    conda-forge
	astor                     0.8.1              pyh9f0ad1d_0    conda-forge
	astroid                   2.6.6            py37h89c1867_0    conda-forge
	astunparse                1.6.3              pyhd8ed1ab_0    conda-forge
	async-timeout             3.0.1                   py_1000    conda-forge
	async_generator           1.10                       py_0    conda-forge
	atomicwrites              1.4.0              pyh9f0ad1d_0    conda-forge
	attrs                     21.2.0             pyhd8ed1ab_0    conda-forge
	autopep8                  1.5.7              pyhd8ed1ab_0    conda-forge
	babel                     2.9.1              pyh44b312d_0    conda-forge
	backcall                  0.2.0              pyh9f0ad1d_0    conda-forge
	backports                 1.0                        py_2    conda-forge
	backports.functools_lru_cache 1.6.4              pyhd8ed1ab_0    conda-forge
	binaryornot               0.4.4                      py_1    conda-forge
	black                     21.8b0             pyhd8ed1ab_0    conda-forge
	bleach                    4.1.0              pyhd8ed1ab_0    conda-forge
	blinker                   1.4                        py_1    conda-forge
	blosc                     1.21.0               h9c3ff4c_0    conda-forge
	boto3                     1.18.39                   <pip>
	botocore                  1.21.39                   <pip>
	brotli                    1.0.9                h7f98852_5    conda-forge
	brotli-bin                1.0.9                h7f98852_5    conda-forge
	brotlipy                  0.7.0           py37h5e8e339_1001    conda-forge
	brunsli                   0.1                  h9c3ff4c_0    conda-forge
	bzip2                     1.0.8                h7f98852_4    conda-forge
	c-ares                    1.17.2               h7f98852_0    conda-forge
	ca-certificates           2021.5.30            ha878542_0    conda-forge
	cachetools                4.2.2              pyhd8ed1ab_0    conda-forge
	cairo                     1.16.0            h6cf1ce9_1008    conda-forge
	certifi                   2021.5.30        py37h89c1867_0    conda-forge
	cffi                      1.14.6           py37hc58025e_0    conda-forge
	cfitsio                   3.470                hb418390_7    conda-forge
	chardet                   4.0.0            py37h89c1867_1    conda-forge
	charls                    2.2.0                h9c3ff4c_0    conda-forge
	click                     8.0.1            py37h89c1867_0    conda-forge
	cloudpickle               2.0.0              pyhd8ed1ab_0    conda-forge
	colorama                  0.4.4              pyh9f0ad1d_0    conda-forge
	cookiecutter              1.7.0                      py_0    conda-forge
	cryptography              3.4.7            py37h5d9358c_0    conda-forge
	cudatoolkit               10.1.243             h036e899_8    conda-forge
	cudnn                     7.6.5.32             hc0a50b0_1    conda-forge
	cupti                     10.1.168                0.conda
	curl                      7.78.0               hea6ffbf_0    conda-forge
	cycler                    0.10.0                     py_2    conda-forge
	cytoolz                   0.11.0           py37h5e8e339_3    conda-forge
	dask-core                 2021.9.0           pyhd8ed1ab_0    conda-forge
	dataclasses               0.8                pyhc8e2a94_3    conda-forge
	dbus                      1.13.6               h48d8840_2    conda-forge
	debugpy                   1.4.1            py37hcd2ae1e_0    conda-forge
	decorator                 5.0.9              pyhd8ed1ab_0    conda-forge
	defusedxml                0.7.1              pyhd8ed1ab_0    conda-forge
	diff-match-patch          20200713           pyh9f0ad1d_0    conda-forge
	docutils                  0.17.1           py37h89c1867_0    conda-forge
	entrypoints               0.3             pyhd8ed1ab_1003    conda-forge
	expat                     2.4.1                h9c3ff4c_0    conda-forge
	ffmpeg                    4.3.2                hca11adc_0    conda-forge
	ffmpeg-python             0.2.0                      py_0    conda-forge
	flake8                    3.9.2              pyhd8ed1ab_0    conda-forge
	fontconfig                2.13.1            hba837de_1005    conda-forge
	freetype                  2.10.4               h0708190_1    conda-forge
	fsspec                    2021.8.1           pyhd8ed1ab_0    conda-forge
	future                    0.18.2           py37h89c1867_3    conda-forge
	gast                      0.4.0              pyh9f0ad1d_0    conda-forge
	gettext                   0.19.8.1          h0b5b191_1005    conda-forge
	giflib                    5.2.1                h36c2ea0_2    conda-forge
	git                       2.33.0          pl5321hc30692c_0    conda-forge
	glib                      2.68.4               h9c3ff4c_0    conda-forge
	glib-tools                2.68.4               h9c3ff4c_0    conda-forge
	gmp                       6.2.1                h58526e2_0    conda-forge
	gnutls                    3.6.13               h85f3911_1    conda-forge
	google-auth               1.35.0             pyh6c4a22f_0    conda-forge
	google-auth-oauthlib      0.4.6              pyhd8ed1ab_0    conda-forge
	google-pasta              0.2.0              pyh8c360ce_0    conda-forge
	graphite2                 1.3.13            h58526e2_1001    conda-forge
	grpcio                    1.38.1           py37hb27c1af_0    conda-forge
	gst-plugins-base          1.18.5               hf529b03_0    conda-forge
	gstreamer                 1.18.5               h76c114f_0    conda-forge
	h5py                      2.10.0          nompi_py37ha3df211_106    conda-forge
	harfbuzz                  2.9.1                h83ec7ef_0    conda-forge
	hdf5                      1.10.6          nompi_h6a2412b_1114    conda-forge
	icu                       68.1                 h58526e2_0    conda-forge
	idna                      2.10               pyh9f0ad1d_0    conda-forge
	imagecodecs               2021.7.30        py37hfe5a812_0    conda-forge
	imageio                   2.9.0                      py_0    conda-forge
	imagesize                 1.2.0                      py_0    conda-forge
	importlib-metadata        4.8.1            py37h89c1867_0    conda-forge
	importlib_metadata        4.8.1                hd8ed1ab_0    conda-forge
	inflection                0.5.1              pyh9f0ad1d_0    conda-forge
	intervaltree              3.0.2                      py_0    conda-forge
	ipykernel                 6.4.0            py37h6531663_0    conda-forge
	ipython                   7.27.0           py37h6531663_0    conda-forge
	ipython_genutils          0.2.0                      py_1    conda-forge
	isort                     5.9.3              pyhd8ed1ab_0    conda-forge
	jasper                    1.900.1           h07fcdf6_1006    conda-forge
	jedi                      0.18.0           py37h89c1867_2    conda-forge
	jeepney                   0.7.1              pyhd8ed1ab_0    conda-forge
	jinja2                    3.0.1              pyhd8ed1ab_0    conda-forge
	jinja2-time               0.2.0                      py_2    conda-forge
	jmespath                  0.10.0                    <pip>
	jpeg                      9d                   h36c2ea0_0    conda-forge
	jsonschema                3.2.0              pyhd8ed1ab_3    conda-forge
	jupyter_client            6.1.12             pyhd8ed1ab_0    conda-forge
	jupyter_core              4.7.1            py37h89c1867_0    conda-forge
	jupyterlab_pygments       0.1.2              pyh9f0ad1d_0    conda-forge
	jxrlib                    1.1                  h7f98852_2    conda-forge
	keras-preprocessing       1.1.2              pyhd8ed1ab_0    conda-forge
	keyring                   23.1.0           py37h89c1867_0    conda-forge
	kiwisolver                1.3.2            py37h2527ec5_0    conda-forge
	krb5                      1.19.2               hcc1bbae_0    conda-forge
	lame                      3.100             h7f98852_1001    conda-forge
	lazy-object-proxy         1.6.0            py37h5e8e339_0    conda-forge
	lcms2                     2.12                 hddcbb42_0    conda-forge
	ld_impl_linux-64          2.36.1               hea4e1c9_2    conda-forge
	lerc                      2.2.1                h9c3ff4c_0    conda-forge
	libaec                    1.0.5                h9c3ff4c_0    conda-forge
	libblas                   3.9.0           11_linux64_openblas    conda-forge
	libbrotlicommon           1.0.9                h7f98852_5    conda-forge
	libbrotlidec              1.0.9                h7f98852_5    conda-forge
	libbrotlienc              1.0.9                h7f98852_5    conda-forge
	libcblas                  3.9.0           11_linux64_openblas    conda-forge
	libclang                  11.1.0          default_ha53f305_1    conda-forge
	libcurl                   7.78.0               h2574ce0_0    conda-forge
	libdeflate                1.8                  h7f98852_0    conda-forge
	libedit                   3.1.20191231         he28a2e2_2    conda-forge
	libev                     4.33                 h516909a_1    conda-forge
	libevent                  2.1.10               hcdb4288_3    conda-forge
	libffi                    3.3                  h58526e2_2    conda-forge
	libgcc-ng                 11.1.0               hc902ee8_8    conda-forge
	libgfortran-ng            11.1.0               h69a702a_8    conda-forge
	libgfortran5              11.1.0               h6c583b3_8    conda-forge
	libglib                   2.68.4               h3e27bee_0    conda-forge
	libgomp                   11.1.0               hc902ee8_8    conda-forge
	libiconv                  1.16                 h516909a_0    conda-forge
	liblapack                 3.9.0           11_linux64_openblas    conda-forge
	liblapacke                3.9.0           11_linux64_openblas    conda-forge
	libllvm11                 11.1.0               hf817b99_2    conda-forge
	libnghttp2                1.43.0               h812cca2_0    conda-forge
	libogg                    1.3.4                h7f98852_1    conda-forge
	libopenblas               0.3.17          pthreads_h8fe5266_1    conda-forge
	libopencv                 4.5.3            py37h25009ff_1    conda-forge
	libopus                   1.3.1                h7f98852_1    conda-forge
	libpng                    1.6.37               h21135ba_2    conda-forge
	libpq                     13.3                 hd57d9b9_0    conda-forge
	libprotobuf               3.16.0               h780b84a_0    conda-forge
	libsodium                 1.0.18               h36c2ea0_1    conda-forge
	libspatialindex           1.9.3                h9c3ff4c_4    conda-forge
	libssh2                   1.10.0               ha56f1ee_0    conda-forge
	libstdcxx-ng              11.1.0               h56837e0_8    conda-forge
	libtiff                   4.3.0                hf544144_0    conda-forge
	libuuid                   2.32.1            h7f98852_1000    conda-forge
	libvorbis                 1.3.7                h9c3ff4c_0    conda-forge
	libwebp-base              1.2.1                h7f98852_0    conda-forge
	libxcb                    1.13              h7f98852_1003    conda-forge
	libxkbcommon              1.0.3                he3ba5ed_0    conda-forge
	libxml2                   2.9.12               h72842e0_0    conda-forge
	libzopfli                 1.0.3                h9c3ff4c_0    conda-forge
	locket                    0.2.0                      py_2    conda-forge
	lz4-c                     1.9.3                h9c3ff4c_1    conda-forge
	markdown                  3.3.4              pyhd8ed1ab_0    conda-forge
	markupsafe                2.0.1            py37h5e8e339_0    conda-forge
	matplotlib-base           3.4.3            py37h1058ff1_0    conda-forge
	matplotlib-inline         0.1.3              pyhd8ed1ab_0    conda-forge
	mccabe                    0.6.1                      py_1    conda-forge
	mistune                   0.8.4           py37h5e8e339_1004    conda-forge
	multidict                 5.1.0            py37h5e8e339_1    conda-forge
	mypy_extensions           0.4.3            py37h89c1867_3    conda-forge
	mysql-common              8.0.25               ha770c72_2    conda-forge
	mysql-libs                8.0.25               hfa10184_2    conda-forge
	nbclient                  0.5.4              pyhd8ed1ab_0    conda-forge
	nbconvert                 6.1.0            py37h89c1867_0    conda-forge
	nbformat                  5.1.3              pyhd8ed1ab_0    conda-forge
	ncurses                   6.2                  h58526e2_4    conda-forge
	nest-asyncio              1.5.1              pyhd8ed1ab_0    conda-forge
	nettle                    3.6                  he412f7d_0    conda-forge
	networkx                  2.5                        py_0    conda-forge
	nspr                      4.30                 h9c3ff4c_0    conda-forge
	nss                       3.69                 hb5efdd6_0    conda-forge
	numpy                     1.21.2           py37h31617e3_0    conda-forge
	numpydoc                  1.1.0                      py_1    conda-forge
	oauthlib                  3.1.1              pyhd8ed1ab_0    conda-forge
	olefile                   0.46               pyh9f0ad1d_1    conda-forge
	opencv                    4.5.3            py37h89c1867_1    conda-forge
	openh264                  2.1.1                h780b84a_0    conda-forge
	openjpeg                  2.4.0                hb52868f_1    conda-forge
	openssl                   1.1.1l               h7f98852_0    conda-forge
	opt_einsum                3.3.0              pyhd8ed1ab_1    conda-forge
	packaging                 21.0               pyhd8ed1ab_0    conda-forge
	pandoc                    2.14.2               h7f98852_0    conda-forge
	pandocfilters             1.4.2                      py_1    conda-forge
	parso                     0.8.2              pyhd8ed1ab_0    conda-forge
	partd                     1.2.0              pyhd8ed1ab_0    conda-forge
	pathspec                  0.9.0              pyhd8ed1ab_0    conda-forge
	pcre                      8.45                 h9c3ff4c_0    conda-forge
	pcre2                     10.37                h032f7d1_0    conda-forge
	perl                      5.32.1          0_h7f98852_perl5    conda-forge
	pexpect                   4.8.0              pyh9f0ad1d_2    conda-forge
	pickleshare               0.7.5                   py_1003    conda-forge
	pillow                    8.3.2            py37h0f21c89_0    conda-forge
	pip                       21.2.4             pyhd8ed1ab_0    conda-forge
	pixman                    0.40.0               h36c2ea0_0    conda-forge
	platformdirs              2.3.0              pyhd8ed1ab_0    conda-forge
	pluggy                    0.13.1           py37h89c1867_4    conda-forge
	pooch                     1.5.1              pyhd8ed1ab_0    conda-forge
	poyo                      0.5.0                      py_0    conda-forge
	prompt-toolkit            3.0.20             pyha770c72_0    conda-forge
	protobuf                  3.16.0           py37hcd2ae1e_0    conda-forge
	psutil                    5.8.0            py37h5e8e339_1    conda-forge
	pthread-stubs             0.4               h36c2ea0_1001    conda-forge
	ptyprocess                0.7.0              pyhd3deb0d_0    conda-forge
	py-opencv                 4.5.3            py37h6531663_1    conda-forge
	pyasn1                    0.4.8                      py_0    conda-forge
	pyasn1-modules            0.2.7                      py_0    conda-forge
	pycodestyle               2.7.0              pyhd8ed1ab_0    conda-forge
	pycparser                 2.20               pyh9f0ad1d_2    conda-forge
	pydocstyle                6.1.1              pyhd8ed1ab_0    conda-forge
	pyflakes                  2.3.1              pyhd8ed1ab_0    conda-forge
	pygments                  2.10.0             pyhd8ed1ab_0    conda-forge
	pyjwt                     2.1.0              pyhd8ed1ab_0    conda-forge
	pylint                    2.9.6              pyhd8ed1ab_0    conda-forge
	pyls-spyder               0.4.0              pyhd8ed1ab_0    conda-forge
	pyopenssl                 20.0.1             pyhd8ed1ab_0    conda-forge
	pyparsing                 2.4.7              pyh9f0ad1d_0    conda-forge
	pyqt                      5.12.3           py37h89c1867_7    conda-forge
	pyqt-impl                 5.12.3           py37he336c9b_7    conda-forge
	pyqt5-sip                 4.19.18          py37hcd2ae1e_7    conda-forge
	pyqtchart                 5.12             py37he336c9b_7    conda-forge
	pyqtwebengine             5.12.1           py37he336c9b_7    conda-forge
	pyrsistent                0.17.3           py37h5e8e339_2    conda-forge
	pysocks                   1.7.1            py37h89c1867_3    conda-forge
	python                    3.7.10          hffdb5ce_100_cpython    conda-forge
	python-bioformats         4.0.5                     <pip>
	python-dateutil           2.8.2              pyhd8ed1ab_0    conda-forge
	python-flatbuffers        2.0                pyhd8ed1ab_0    conda-forge
	python-javabridge         4.0.3                     <pip>
	python-lsp-black          1.0.0              pyhd8ed1ab_0    conda-forge
	python-lsp-jsonrpc        1.0.0              pyhd8ed1ab_0    conda-forge
	python-lsp-server         1.2.2              pyhd8ed1ab_0    conda-forge
	python_abi                3.7                     2_cp37m    conda-forge
	pytz                      2021.1             pyhd8ed1ab_0    conda-forge
	pyu2f                     0.1.5              pyhd8ed1ab_0    conda-forge
	pywavelets                1.1.1            py37hb1e94ed_3    conda-forge
	pyxdg                     0.27               pyhd8ed1ab_0    conda-forge
	pyyaml                    5.4.1            py37h5e8e339_1    conda-forge
	pyzmq                     22.2.1           py37h336d617_0    conda-forge
	qdarkstyle                3.0.2              pyhd8ed1ab_0    conda-forge
	qstylizer                 0.2.1              pyhd8ed1ab_0    conda-forge
	qt                        5.12.9               hda022c4_4    conda-forge
	qtawesome                 1.0.3              pyhd8ed1ab_0    conda-forge
	qtconsole                 5.1.1              pyhd8ed1ab_0    conda-forge
	qtpy                      1.11.0             pyhd8ed1ab_0    conda-forge
	readline                  8.1                  h46c0cb4_0    conda-forge
	regex                     2021.8.28        py37h5e8e339_0    conda-forge
	requests                  2.25.1             pyhd3deb0d_0    conda-forge
	requests-oauthlib         1.3.0              pyh9f0ad1d_0    conda-forge
	rope                      0.19.0             pyhd8ed1ab_0    conda-forge
	rsa                       4.7.2              pyh44b312d_0    conda-forge
	rtree                     0.9.7            py37h0b55af0_2    conda-forge
	s3transfer                0.5.0                     <pip>
	scikit-image              0.18.3           py37he8f5f7f_0    conda-forge
	scipy                     1.7.1            py37hf2a6cf1_0    conda-forge
	secretstorage             3.3.1            py37h89c1867_0    conda-forge
	setuptools                58.0.4           py37h89c1867_0    conda-forge
	six                       1.16.0             pyh6c4a22f_0    conda-forge
	snappy                    1.1.8                he1b5a44_3    conda-forge
	snowballstemmer           2.1.0              pyhd8ed1ab_0    conda-forge
	sortedcontainers          2.4.0              pyhd8ed1ab_0    conda-forge
	sphinx                    4.1.2              pyh6c4a22f_1    conda-forge
	sphinxcontrib-applehelp   1.0.2                      py_0    conda-forge
	sphinxcontrib-devhelp     1.0.2                      py_0    conda-forge
	sphinxcontrib-htmlhelp    2.0.0              pyhd8ed1ab_0    conda-forge
	sphinxcontrib-jsmath      1.0.1                      py_0    conda-forge
	sphinxcontrib-qthelp      1.0.3                      py_0    conda-forge
	sphinxcontrib-serializinghtml 1.1.5              pyhd8ed1ab_0    conda-forge
	spyder                    5.1.3            py37h89c1867_0    conda-forge
	spyder-kernels            2.1.1            py37h89c1867_0    conda-forge
	sqlite                    3.36.0               h9cd32fc_1    conda-forge
	tensorboard               2.6.0              pyhd8ed1ab_1    conda-forge
	tensorboard-data-server   0.6.0            py37hf1a17b8_0    conda-forge
	tensorboard-plugin-wit    1.8.0              pyh44b312d_0    conda-forge
	tensorflow                2.4.1           gpu_py37ha2e99fa_0.conda
	tensorflow-base           2.4.1           gpu_py37h29c2da4_0.conda
	tensorflow-estimator      2.5.0              pyh81a9013_1    conda-forge
	tensorflow-gpu            2.4.1           h30adc30_0.conda
	termcolor                 1.1.0                      py_2    conda-forge
	testpath                  0.5.0              pyhd8ed1ab_0    conda-forge
	textdistance              4.2.1              pyhd8ed1ab_0    conda-forge
	three-merge               0.1.1              pyh9f0ad1d_0    conda-forge
	tifffile                  2021.8.30          pyhd8ed1ab_0    conda-forge
	tinycss2                  1.1.0              pyhd8ed1ab_0    conda-forge
	tk                        8.6.11               h27826a3_1    conda-forge
	toml                      0.10.2             pyhd8ed1ab_0    conda-forge
	tomli                     1.2.1              pyhd8ed1ab_0    conda-forge
	toolz                     0.11.1                     py_0    conda-forge
	tornado                   6.1              py37h5e8e339_1    conda-forge
	traitlets                 5.1.0              pyhd8ed1ab_0    conda-forge
	typed-ast                 1.4.3            py37h5e8e339_0    conda-forge
	typing-extensions         3.10.0.0             hd8ed1ab_0    conda-forge
	typing_extensions         3.10.0.0           pyha770c72_0    conda-forge
	ujson                     4.1.0            py37hcd2ae1e_0    conda-forge
	urllib3                   1.26.6             pyhd8ed1ab_0    conda-forge
	watchdog                  2.1.5            py37h89c1867_0    conda-forge
	wcwidth                   0.2.5              pyh9f0ad1d_2    conda-forge
	webencodings              0.5.1                      py_1    conda-forge
	werkzeug                  2.0.1              pyhd8ed1ab_0    conda-forge
	wheel                     0.37.0             pyhd8ed1ab_1    conda-forge
	whichcraft                0.6.1                      py_0    conda-forge
	wrapt                     1.12.1           py37h5e8e339_3    conda-forge
	wurlitzer                 3.0.2            py37h89c1867_0    conda-forge
	x264                      1!161.3030           h7f98852_1    conda-forge
	xorg-kbproto              1.0.7             h7f98852_1002    conda-forge
	xorg-libice               1.0.10               h7f98852_0    conda-forge
	xorg-libsm                1.2.3             hd9c2040_1000    conda-forge
	xorg-libx11               1.7.2                h7f98852_0    conda-forge
	xorg-libxau               1.0.9                h7f98852_0    conda-forge
	xorg-libxdmcp             1.1.3                h7f98852_0    conda-forge
	xorg-libxext              1.3.4                h7f98852_1    conda-forge
	xorg-libxrender           0.9.10            h7f98852_1003    conda-forge
	xorg-renderproto          0.11.1            h7f98852_1002    conda-forge
	xorg-xextproto            7.3.0             h7f98852_1002    conda-forge
	xorg-xproto               7.0.31            h7f98852_1007    conda-forge
	xz                        5.2.5                h516909a_1    conda-forge
	yaml                      0.2.5                h516909a_0    conda-forge
	yapf                      0.31.0             pyhd8ed1ab_0    conda-forge
	yarl                      1.6.3            py37h5e8e339_2    conda-forge
	zeromq                    4.3.4                h9c3ff4c_1    conda-forge
	zfp                       0.5.5                h9c3ff4c_6    conda-forge
	zipp                      3.5.0              pyhd8ed1ab_0    conda-forge
	zlib                      1.2.11            h516909a_1010    conda-forge
	zstd                      1.5.0                ha95c52a_0    conda-forge


Linux (EL7) conda yml install, TF 2.0
--------------------------------------
Install date 2021-11-11

Kindly provided by Mark Aronson. See issue #11 on gitlab

`conda list` output::

	# packages in environment at /projectnb/sgrolab/maronson/.conda/envs/delta_env:
	#
	# Name                    Version                   Build  Channel
	_libgcc_mutex             0.1                 conda_forge    conda-forge
	_openmp_mutex             4.5                       1_gnu    conda-forge
	_tflow_select             2.1.0                       gpu  
	absl-py                   0.15.0             pyhd8ed1ab_0    conda-forge
	alabaster                 0.7.12                     py_0    conda-forge
	appdirs                   1.4.4              pyh9f0ad1d_0    conda-forge
	argcomplete               1.12.3             pyhd8ed1ab_2    conda-forge
	argh                      0.26.2          pyh9f0ad1d_1002    conda-forge
	arrow                     1.2.1              pyhd8ed1ab_0    conda-forge
	asn1crypto                1.4.0              pyh9f0ad1d_0    conda-forge
	astor                     0.8.1              pyh9f0ad1d_0    conda-forge
	astroid                   2.6.6            py37h89c1867_0    conda-forge
	async_generator           1.10                       py_0    conda-forge
	atomicwrites              1.4.0              pyh9f0ad1d_0    conda-forge
	attrs                     21.2.0             pyhd8ed1ab_0    conda-forge
	autopep8                  1.6.0              pyhd8ed1ab_0    conda-forge
	babel                     2.9.1              pyh44b312d_0    conda-forge
	backcall                  0.2.0              pyh9f0ad1d_0    conda-forge
	backports                 1.0                        py_2    conda-forge
	backports.functools_lru_cache 1.6.4              pyhd8ed1ab_0    conda-forge
	binaryornot               0.4.4                      py_1    conda-forge
	black                     21.10b0            pyhd8ed1ab_0    conda-forge
	bleach                    4.1.0              pyhd8ed1ab_0    conda-forge
	blosc                     1.21.0               h9c3ff4c_0    conda-forge
	boto3                     1.20.3                   pypi_0    pypi
	botocore                  1.23.3                   pypi_0    pypi
	brotli                    1.0.9                h7f98852_6    conda-forge
	brotli-bin                1.0.9                h7f98852_6    conda-forge
	brotlipy                  0.7.0           py37h5e8e339_1003    conda-forge
	brunsli                   0.1                  h9c3ff4c_0    conda-forge
	bzip2                     1.0.8                h7f98852_4    conda-forge
	c-ares                    1.18.1               h7f98852_0    conda-forge
	ca-certificates           2020.10.14                    0    anaconda
	cached-property           1.5.2                hd8ed1ab_1    conda-forge
	cached_property           1.5.2              pyha770c72_1    conda-forge
	cairo                     1.16.0            hcf35c78_1003    conda-forge
	certifi                   2020.6.20                py37_0    anaconda
	cffi                      1.14.4           py37h11fe52a_0    conda-forge
	chardet                   4.0.0            py37h89c1867_2    conda-forge
	charls                    2.2.0                h9c3ff4c_0    conda-forge
	click                     8.0.3            py37h89c1867_1    conda-forge
	cloudpickle               2.0.0              pyhd8ed1ab_0    conda-forge
	colorama                  0.4.4              pyh9f0ad1d_0    conda-forge
	cookiecutter              1.7.0                      py_0    conda-forge
	cryptography              2.5              py37hb7f436b_1    conda-forge
	cudatoolkit               10.0.130             hf841e97_9    conda-forge
	cudnn                     7.6.5.32             ha8d7eb6_1    conda-forge
	cupti                     10.0.130                      0  
	curl                      7.64.0               h646f8bb_0    conda-forge
	cycler                    0.11.0             pyhd8ed1ab_0    conda-forge
	cytoolz                   0.11.2           py37h5e8e339_1    conda-forge
	dask-core                 2021.11.1          pyhd8ed1ab_0    conda-forge
	dataclasses               0.8                pyhc8e2a94_3    conda-forge
	dbus                      1.13.6               hfdff14a_1    conda-forge
	debugpy                   1.5.1            py37hcd2ae1e_0    conda-forge
	decorator                 5.1.0              pyhd8ed1ab_0    conda-forge
	defusedxml                0.7.1              pyhd8ed1ab_0    conda-forge
	diff-match-patch          20200713           pyh9f0ad1d_0    conda-forge
	docutils                  0.17.1           py37h89c1867_0    conda-forge
	entrypoints               0.3             pyhd8ed1ab_1003    conda-forge
	expat                     2.4.1                h9c3ff4c_0    conda-forge
	ffmpeg                    4.4.0                hca11adc_2    conda-forge
	ffmpeg-python             0.2.0                      py_0    conda-forge
	flake8                    3.9.2              pyhd8ed1ab_0    conda-forge
	fontconfig                2.13.1            hba837de_1005    conda-forge
	freetype                  2.10.4               h0708190_1    conda-forge
	fsspec                    2021.11.0          pyhd8ed1ab_0    conda-forge
	future                    0.18.2           py37h89c1867_4    conda-forge
	gast                      0.2.2                      py_0    conda-forge
	gettext                   0.19.8.1          hf34092f_1004    conda-forge
	giflib                    5.2.1                h36c2ea0_2    conda-forge
	git                       2.20.1          pl526hc122a05_1001    conda-forge
	glib                      2.66.3               h58526e2_0    conda-forge
	gmp                       6.2.1                h58526e2_0    conda-forge
	gnutls                    3.6.13               h85f3911_1    conda-forge
	google-pasta              0.2.0              pyh8c360ce_0    conda-forge
	graphite2                 1.3.13            h58526e2_1001    conda-forge
	grpcio                    1.16.0          py37h4f00d22_1000    conda-forge
	gst-plugins-base          1.14.5               h0935bb2_2    conda-forge
	gstreamer                 1.14.5               h36ae1b5_2    conda-forge
	h5py                      2.10.0           py37hd6299e0_1    anaconda
	harfbuzz                  2.4.0                h9f30f68_3    conda-forge
	hdf5                      1.10.6          nompi_h3c11f04_101    conda-forge
	icu                       64.2                 he1b5a44_1    conda-forge
	idna                      2.10               pyh9f0ad1d_0    conda-forge
	imagecodecs               2021.4.28        py37hd0c323f_0    conda-forge
	imageio                   2.9.0                      py_0    conda-forge
	imagesize                 1.3.0              pyhd8ed1ab_0    conda-forge
	importlib-metadata        4.8.2            py37h89c1867_0    conda-forge
	importlib_metadata        4.8.2                hd8ed1ab_0    conda-forge
	importlib_resources       5.4.0              pyhd8ed1ab_0    conda-forge
	inflection                0.5.1              pyh9f0ad1d_0    conda-forge
	intervaltree              3.0.2                      py_0    conda-forge
	ipykernel                 6.5.0            py37h6531663_0    conda-forge
	ipython                   7.29.0           py37h6531663_0    conda-forge
	ipython_genutils          0.2.0                      py_1    conda-forge
	isort                     5.10.1             pyhd8ed1ab_0    conda-forge
	jasper                    1.900.1           h07fcdf6_1006    conda-forge
	jbig                      2.1               h7f98852_2003    conda-forge
	jedi                      0.18.0           py37h89c1867_3    conda-forge
	jeepney                   0.7.1              pyhd8ed1ab_0    conda-forge
	jinja2                    3.0.3              pyhd8ed1ab_0    conda-forge
	jinja2-time               0.2.0                      py_2    conda-forge
	jmespath                  0.10.0                   pypi_0    pypi
	jpeg                      9d                   h36c2ea0_0    conda-forge
	jsonschema                4.2.1              pyhd8ed1ab_0    conda-forge
	jupyter_client            6.1.12             pyhd8ed1ab_0    conda-forge
	jupyter_core              4.9.1            py37h89c1867_0    conda-forge
	jupyterlab_pygments       0.1.2              pyh9f0ad1d_0    conda-forge
	jxrlib                    1.1                  h7f98852_2    conda-forge
	keras-applications        1.0.8                      py_1    conda-forge
	keras-preprocessing       1.1.2              pyhd8ed1ab_0    conda-forge
	keyring                   23.2.1           py37h89c1867_0    conda-forge
	kiwisolver                1.3.2            py37h2527ec5_1    conda-forge
	krb5                      1.16.3            hc83ff2d_1000    conda-forge
	lame                      3.100             h7f98852_1001    conda-forge
	lazy-object-proxy         1.6.0            py37h5e8e339_1    conda-forge
	lcms2                     2.12                 hddcbb42_0    conda-forge
	lerc                      2.2.1                h9c3ff4c_0    conda-forge
	libaec                    1.0.6                h9c3ff4c_0    conda-forge
	libblas                   3.9.0                8_openblas    conda-forge
	libbrotlicommon           1.0.9                h7f98852_6    conda-forge
	libbrotlidec              1.0.9                h7f98852_6    conda-forge
	libbrotlienc              1.0.9                h7f98852_6    conda-forge
	libcblas                  3.9.0                8_openblas    conda-forge
	libclang                  9.0.1           default_ha53f305_2    conda-forge
	libcurl                   7.64.0               h01ee5af_0    conda-forge
	libdeflate                1.7                  h7f98852_5    conda-forge
	libedit                   3.1.20191231         he28a2e2_2    conda-forge
	libffi                    3.2.1             he1b5a44_1007    conda-forge
	libgcc-ng                 11.2.0              h1d223b6_11    conda-forge
	libgfortran-ng            7.5.0               h14aa051_19    conda-forge
	libgfortran4              7.5.0               h14aa051_19    conda-forge
	libglib                   2.66.3               hbe7bbb4_0    conda-forge
	libgomp                   11.2.0              h1d223b6_11    conda-forge
	libiconv                  1.16                 h516909a_0    conda-forge
	liblapack                 3.9.0                8_openblas    conda-forge
	liblapacke                3.9.0                8_openblas    conda-forge
	libllvm9                  9.0.1           default_hc23dcda_4    conda-forge
	libopenblas               0.3.12          pthreads_hb3c22a3_1    conda-forge
	libopencv                 4.5.3            py37h25009ff_1    conda-forge
	libpng                    1.6.37               h21135ba_2    conda-forge
	libprotobuf               3.16.0               h780b84a_0    conda-forge
	libsodium                 1.0.18               h36c2ea0_1    conda-forge
	libspatialindex           1.9.3                h9c3ff4c_4    conda-forge
	libssh2                   1.8.0             h1ad7b7a_1003    conda-forge
	libstdcxx-ng              11.2.0              he4da1e4_11    conda-forge
	libtiff                   4.3.0                hf544144_1    conda-forge
	libuuid                   2.32.1            h7f98852_1000    conda-forge
	libvpx                    1.11.0               h9c3ff4c_3    conda-forge
	libwebp-base              1.2.1                h7f98852_0    conda-forge
	libxcb                    1.13              h7f98852_1003    conda-forge
	libxkbcommon              0.10.0               he1b5a44_0    conda-forge
	libxml2                   2.9.10               hee79883_0    conda-forge
	libzlib                   1.2.11            h36c2ea0_1013    conda-forge
	libzopfli                 1.0.3                h9c3ff4c_0    conda-forge
	locket                    0.2.0                      py_2    conda-forge
	lz4-c                     1.9.3                h9c3ff4c_1    conda-forge
	markdown                  3.3.4              pyhd8ed1ab_0    conda-forge
	markupsafe                2.0.1            py37h5e8e339_1    conda-forge
	matplotlib-base           3.4.3            py37h1058ff1_1    conda-forge
	matplotlib-inline         0.1.3              pyhd8ed1ab_0    conda-forge
	mccabe                    0.6.1                      py_1    conda-forge
	mistune                   0.8.4           py37h5e8e339_1005    conda-forge
	mypy_extensions           0.4.3            py37h89c1867_4    conda-forge
	nbclient                  0.5.5              pyhd8ed1ab_0    conda-forge
	nbconvert                 6.2.0            py37h89c1867_0    conda-forge
	nbformat                  5.1.3              pyhd8ed1ab_0    conda-forge
	ncurses                   6.2                  h58526e2_4    conda-forge
	nest-asyncio              1.5.1              pyhd8ed1ab_0    conda-forge
	nettle                    3.6                  he412f7d_0    conda-forge
	networkx                  2.6.3              pyhd8ed1ab_1    conda-forge
	nspr                      4.32                 h9c3ff4c_1    conda-forge
	nss                       3.59                 h2c00c37_0    conda-forge
	numpy                     1.21.4           py37h31617e3_0    conda-forge
	numpydoc                  1.1.0                      py_1    conda-forge
	olefile                   0.46               pyh9f0ad1d_1    conda-forge
	opencv                    4.5.3            py37h89c1867_1    conda-forge
	openh264                  2.1.1                h780b84a_0    conda-forge
	openjpeg                  2.4.0                hb52868f_1    conda-forge
	openssl                   1.0.2u               h7b6447c_0    anaconda
	opt_einsum                3.3.0              pyhd8ed1ab_1    conda-forge
	packaging                 21.0               pyhd8ed1ab_0    conda-forge
	pandas                    1.3.4            py37he8f5f7f_1    conda-forge
	pandoc                    2.16.1               h7f98852_0    conda-forge
	pandocfilters             1.5.0              pyhd8ed1ab_0    conda-forge
	parso                     0.8.2              pyhd8ed1ab_0    conda-forge
	partd                     1.2.0              pyhd8ed1ab_0    conda-forge
	pathspec                  0.9.0              pyhd8ed1ab_0    conda-forge
	pcre                      8.45                 h9c3ff4c_0    conda-forge
	perl                      5.26.2            h36c2ea0_1008    conda-forge
	pexpect                   4.8.0              pyh9f0ad1d_2    conda-forge
	pickleshare               0.7.5                   py_1003    conda-forge
	pillow                    8.4.0            py37h0f21c89_0    conda-forge
	pip                       21.3.1             pyhd8ed1ab_0    conda-forge
	pixman                    0.38.0            h516909a_1003    conda-forge
	platformdirs              2.3.0              pyhd8ed1ab_0    conda-forge
	pluggy                    1.0.0            py37h89c1867_2    conda-forge
	pooch                     1.5.2              pyhd8ed1ab_0    conda-forge
	poyo                      0.5.0                      py_0    conda-forge
	prompt-toolkit            3.0.22             pyha770c72_0    conda-forge
	protobuf                  3.16.0           py37hcd2ae1e_0    conda-forge
	psutil                    5.8.0            py37h5e8e339_2    conda-forge
	pthread-stubs             0.4               h36c2ea0_1001    conda-forge
	ptyprocess                0.7.0              pyhd3deb0d_0    conda-forge
	py-opencv                 4.5.3            py37h6531663_1    conda-forge
	pycodestyle               2.7.0              pyhd8ed1ab_0    conda-forge
	pycparser                 2.21               pyhd8ed1ab_0    conda-forge
	pydocstyle                6.1.1              pyhd8ed1ab_0    conda-forge
	pyflakes                  2.3.1              pyhd8ed1ab_0    conda-forge
	pygments                  2.10.0             pyhd8ed1ab_0    conda-forge
	pylint                    2.9.6              pyhd8ed1ab_0    conda-forge
	pyls-spyder               0.4.0              pyhd8ed1ab_0    conda-forge
	pyopenssl                 19.0.0                   py37_0    conda-forge
	pyparsing                 3.0.5              pyhd8ed1ab_0    conda-forge
	pyqt                      5.12.3           py37h8685d9f_3    conda-forge
	pyqt5-sip                 4.19.18                  pypi_0    pypi
	pyqtchart                 5.12                     pypi_0    pypi
	pyqtwebengine             5.12.1                   pypi_0    pypi
	pyrsistent                0.18.0           py37h5e8e339_0    conda-forge
	pysocks                   1.7.1            py37h89c1867_4    conda-forge
	python                    3.7.0             hd21baee_1006    conda-forge
	python-bioformats         4.0.5                    pypi_0    pypi
	python-dateutil           2.8.2              pyhd8ed1ab_0    conda-forge
	python-javabridge         4.0.3                    pypi_0    pypi
	python-lsp-black          1.0.0              pyhd8ed1ab_0    conda-forge
	python-lsp-jsonrpc        1.0.0              pyhd8ed1ab_0    conda-forge
	python-lsp-server         1.2.4              pyhd8ed1ab_0    conda-forge
	python_abi                3.7                     2_cp37m    conda-forge
	pytz                      2021.3             pyhd8ed1ab_0    conda-forge
	pywavelets                1.2.0            py37hb1e94ed_0    conda-forge
	pyxdg                     0.27               pyhd8ed1ab_0    conda-forge
	pyyaml                    6.0              py37h5e8e339_3    conda-forge
	pyzmq                     22.3.0           py37h336d617_1    conda-forge
	qdarkstyle                3.0.2              pyhd8ed1ab_0    conda-forge
	qstylizer                 0.2.1              pyhd8ed1ab_0    conda-forge
	qt                        5.12.5               hd8c4c69_1    conda-forge
	qtawesome                 1.1.0              pyhd8ed1ab_0    conda-forge
	qtconsole                 5.1.1              pyhd8ed1ab_0    conda-forge
	qtpy                      1.11.2             pyhd8ed1ab_0    conda-forge
	readline                  7.0               hf8c457e_1001    conda-forge
	regex                     2021.11.10       py37h5e8e339_0    conda-forge
	requests                  2.25.1             pyhd3deb0d_0    conda-forge
	rope                      0.21.0             pyhd8ed1ab_0    conda-forge
	rtree                     0.9.7            py37h0b55af0_2    conda-forge
	s3transfer                0.5.0                    pypi_0    pypi
	scikit-image              0.18.3           py37he8f5f7f_0    conda-forge
	scipy                     1.5.3            py37h8911b10_0    conda-forge
	secretstorage             3.3.1            py37h89c1867_0    conda-forge
	setuptools                58.5.3           py37h89c1867_0    conda-forge
	six                       1.16.0             pyh6c4a22f_0    conda-forge
	snappy                    1.1.8                he1b5a44_3    conda-forge
	snowballstemmer           2.1.0              pyhd8ed1ab_0    conda-forge
	sortedcontainers          2.4.0              pyhd8ed1ab_0    conda-forge
	sphinx                    4.3.0              pyh6c4a22f_0    conda-forge
	sphinxcontrib-applehelp   1.0.2                      py_0    conda-forge
	sphinxcontrib-devhelp     1.0.2                      py_0    conda-forge
	sphinxcontrib-htmlhelp    2.0.0              pyhd8ed1ab_0    conda-forge
	sphinxcontrib-jsmath      1.0.1                      py_0    conda-forge
	sphinxcontrib-qthelp      1.0.3                      py_0    conda-forge
	sphinxcontrib-serializinghtml 1.1.5              pyhd8ed1ab_0    conda-forge
	spyder                    5.1.5            py37h89c1867_1    conda-forge
	spyder-kernels            2.1.3            py37h89c1867_0    conda-forge
	sqlite                    3.33.0               h62c20be_0  
	tensorboard               2.0.0              pyhb38c66f_1  
	tensorflow                2.0.0           gpu_py37h768510d_0  
	tensorflow-base           2.0.0           gpu_py37h0ec5d1f_0  
	tensorflow-estimator      2.0.0              pyh2649769_0  
	tensorflow-gpu            2.0.0                h0d30ee6_0  
	termcolor                 1.1.0                      py_2    conda-forge
	testpath                  0.5.0              pyhd8ed1ab_0    conda-forge
	textdistance              4.2.2              pyhd8ed1ab_0    conda-forge
	three-merge               0.1.1              pyh9f0ad1d_0    conda-forge
	tifffile                  2021.7.2           pyhd8ed1ab_0    conda-forge
	tinycss2                  1.1.0              pyhd8ed1ab_0    conda-forge
	tk                        8.6.11               h27826a3_1    conda-forge
	toml                      0.10.2             pyhd8ed1ab_0    conda-forge
	tomli                     1.2.2              pyhd8ed1ab_0    conda-forge
	toolz                     0.11.2             pyhd8ed1ab_0    conda-forge
	tornado                   6.1              py37h5e8e339_2    conda-forge
	traitlets                 5.1.1              pyhd8ed1ab_0    conda-forge
	typed-ast                 1.4.3            py37h5e8e339_1    conda-forge
	typing-extensions         3.10.0.2             hd8ed1ab_0    conda-forge
	typing_extensions         3.10.0.2           pyha770c72_0    conda-forge
	ujson                     4.2.0            py37hcd2ae1e_1    conda-forge
	urllib3                   1.26.7             pyhd8ed1ab_0    conda-forge
	watchdog                  2.1.6            py37h89c1867_1    conda-forge
	wcwidth                   0.2.5              pyh9f0ad1d_2    conda-forge
	webencodings              0.5.1                      py_1    conda-forge
	werkzeug                  0.16.1                     py_0    conda-forge
	wheel                     0.37.0             pyhd8ed1ab_1    conda-forge
	whichcraft                0.6.1                      py_0    conda-forge
	wrapt                     1.12.1           py37h5e8e339_3    conda-forge
	wurlitzer                 3.0.2            py37h89c1867_1    conda-forge
	x264                      1!161.3030           h7f98852_1    conda-forge
	xorg-kbproto              1.0.7             h7f98852_1002    conda-forge
	xorg-libice               1.0.10               h7f98852_0    conda-forge
	xorg-libsm                1.2.3             hd9c2040_1000    conda-forge
	xorg-libx11               1.7.2                h7f98852_0    conda-forge
	xorg-libxau               1.0.9                h7f98852_0    conda-forge
	xorg-libxdmcp             1.1.3                h7f98852_0    conda-forge
	xorg-libxext              1.3.4                h7f98852_1    conda-forge
	xorg-libxrender           0.9.10            h7f98852_1003    conda-forge
	xorg-renderproto          0.11.1            h7f98852_1002    conda-forge
	xorg-xextproto            7.3.0             h7f98852_1002    conda-forge
	xorg-xproto               7.0.31            h7f98852_1007    conda-forge
	xz                        5.2.5                h516909a_1    conda-forge
	yaml                      0.2.5                h516909a_0    conda-forge
	yapf                      0.31.0             pyhd8ed1ab_0    conda-forge
	zeromq                    4.3.4                h9c3ff4c_1    conda-forge
	zfp                       0.5.5                h9c3ff4c_7    conda-forge
	zipp                      3.6.0              pyhd8ed1ab_0    conda-forge
	zlib                      1.2.11            h36c2ea0_1013    conda-forge
	zstd                      1.5.0                ha95c52a_0    conda-forge

Windows installs
================

Windows 10 pip install - TF 2.7
-------------------------------

install: 2021-11-14

First installed CUDA 11.2.2 and cuDNN 8.2.1

Created dedicated conda env with python=3.8

`pip list` output::

	Package                      Version
	---------------------------- ---------
	absl-py                      1.0.0
	astunparse                   1.6.3
	boto3                        1.20.7
	botocore                     1.23.7
	cachetools                   4.2.4
	certifi                      2021.10.8
	charset-normalizer           2.0.7
	cycler                       0.11.0
	ffmpeg-python                0.2.0
	flatbuffers                  2.0
	fonttools                    4.28.1
	future                       0.18.2
	gast                         0.4.0
	google-auth                  2.3.3
	google-auth-oauthlib         0.4.6
	google-pasta                 0.2.0
	grpcio                       1.41.1
	h5py                         3.6.0
	idna                         3.3
	imageio                      2.10.4
	importlib-metadata           4.8.2
	jmespath                     0.10.0
	keras                        2.7.0
	Keras-Preprocessing          1.1.2
	kiwisolver                   1.3.2
	libclang                     12.0.0
	Markdown                     3.3.5
	matplotlib                   3.5.0
	networkx                     2.6.3
	numpy                        1.21.4
	oauthlib                     3.1.1
	opencv-python                4.5.4.58
	opt-einsum                   3.3.0
	packaging                    21.2
	Pillow                       8.4.0
	pip                          21.0.1
	protobuf                     3.19.1
	pyasn1                       0.4.8
	pyasn1-modules               0.2.8
	pyparsing                    2.4.7
	python-bioformats            4.0.5
	python-dateutil              2.8.2
	python-javabridge            4.0.3
	PyWavelets                   1.2.0
	requests                     2.26.0
	requests-oauthlib            1.3.0
	rsa                          4.7.2
	s3transfer                   0.5.0
	scikit-image                 0.18.3
	scipy                        1.7.2
	setuptools                   58.0.4
	setuptools-scm               6.3.2
	six                          1.16.0
	tensorboard                  2.7.0
	tensorboard-data-server      0.6.1
	tensorboard-plugin-wit       1.8.0
	tensorflow                   2.7.0
	tensorflow-estimator         2.7.0
	tensorflow-io-gcs-filesystem 0.22.0
	termcolor                    1.1.0
	tifffile                     2021.11.2
	tomli                        1.2.2
	typing-extensions            4.0.0
	urllib3                      1.26.7
	Werkzeug                     2.0.2
	wheel                        0.37.0
	wincertstore                 0.2
	wrapt                        1.13.3
	zipp                         3.6.0

Windows 10 conda yml install, TF 2.6
------------------------------------

Jan 11, 2022

`conda list` output::

        # packages in environment at C:\Users\jeanbaptiste\Anaconda3\envs\delta_env:
        #
        # Name                    Version                   Build  Channel
        _tflow_select             2.1.0                       gpu
        abseil-cpp                20210324.2           hd77b12b_0
        absl-py                   0.15.0             pyhd3eb1b0_0
        aiohttp                   3.8.1            py39h2bbff1b_0
        aiosignal                 1.2.0              pyhd3eb1b0_0
        astor                     0.8.1            py39haa95532_0
        astunparse                1.6.3                      py_0
        async-timeout             4.0.1              pyhd3eb1b0_0
        atomicwrites              1.4.0              pyh9f0ad1d_0    conda-forge
        attrs                     21.2.0             pyhd3eb1b0_0
        blas                      1.0                         mkl
        blinker                   1.4              py39haa95532_0
        blosc                     1.21.0               h19a0ad4_0
        brotli                    1.0.9                ha925a31_2
        brotlipy                  0.7.0           py39h2bbff1b_1003
        bzip2                     1.0.8                he774522_0
        ca-certificates           2021.10.8            h5b45459_0    conda-forge
        cachetools                4.2.2              pyhd3eb1b0_0
        certifi                   2021.10.8        py39hcbf5309_1    conda-forge
        cffi                      1.15.0           py39h2bbff1b_0
        cfitsio                   3.470                he774522_6
        charls                    2.2.0                h6c2663c_0
        charset-normalizer        2.0.4              pyhd3eb1b0_0
        click                     8.0.3              pyhd3eb1b0_0
        cloudpickle               2.0.0              pyhd3eb1b0_0
        colorama                  0.4.4              pyh9f0ad1d_0    conda-forge
        cryptography              3.4.8            py39h71e12ea_0
        cudatoolkit               11.3.1               h59b6b97_2
        cudnn                     8.2.1                cuda11.3_0
        cycler                    0.11.0             pyhd3eb1b0_0
        cytoolz                   0.11.0           py39h2bbff1b_0
        dask-core                 2021.10.0          pyhd3eb1b0_0
        dataclasses               0.8                pyh6d0b6a4_7
        ffmpeg                    4.2.2                he774522_0
        ffmpeg-python             0.2.0                      py_0    conda-forge
        flatbuffers               2.0.0                h6c2663c_0
        fonttools                 4.25.0             pyhd3eb1b0_0
        freeglut                  3.0.0                h6538335_5
        freetype                  2.10.4               hd328e21_0
        frozenlist                1.2.0            py39h2bbff1b_0
        fsspec                    2021.10.1          pyhd3eb1b0_0
        future                    0.18.2           py39haa95532_1
        gast                      0.4.0              pyhd3eb1b0_0
        giflib                    5.2.1                h62dcd97_0
        google-auth               1.33.0             pyhd3eb1b0_0
        google-auth-oauthlib      0.4.1                      py_2
        google-pasta              0.2.0              pyhd3eb1b0_0
        grpcio                    1.42.0           py39hc60d5dd_0
        h5py                      3.6.0            py39h3de5c98_0
        hdf5                      1.10.6               h7ebc959_0
        icc_rt                    2019.0.0             h0cc432a_1
        icu                       68.1                 h6c2663c_0
        idna                      3.3                pyhd3eb1b0_0
        imagecodecs               2021.8.26        py39ha1f97ea_0
        imageio                   2.9.0              pyhd3eb1b0_0
        importlib-metadata        4.8.2            py39haa95532_0
        iniconfig                 1.1.1              pyh9f0ad1d_0    conda-forge
        intel-openmp              2021.4.0          haa95532_3556
        jasper                    2.0.14               hea7d32e_2
        jpeg                      9d                   h2bbff1b_0
        keras-preprocessing       1.1.2              pyhd3eb1b0_0
        kiwisolver                1.3.1            py39hd77b12b_0
        lcms2                     2.12                 h83e58a3_0
        lerc                      3.0                  hd77b12b_0
        libaec                    1.0.4                h33f27b4_1
        libblas                   3.9.0              12_win64_mkl    conda-forge
        libcblas                  3.9.0              12_win64_mkl    conda-forge
        libclang                  11.1.0          default_h5c34c98_1    conda-forge
        libcurl                   7.80.0               h86230a5_0
        libdeflate                1.8                  h2bbff1b_5
        liblapack                 3.9.0              12_win64_mkl    conda-forge
        liblapacke                3.9.0              12_win64_mkl    conda-forge
        libopencv                 4.5.1            py39h27d8466_0    conda-forge
        libpng                    1.6.37               h2a8f88b_0
        libprotobuf               3.17.2               h23ce68f_1
        libssh2                   1.9.0                h7a1dbc1_1
        libtiff                   4.2.0                hd0e1b90_0
        libwebp                   1.2.0                h2bbff1b_0
        libwebp-base              1.2.0                h2bbff1b_0
        libzopfli                 1.0.3                ha925a31_0
        locket                    0.2.1            py39haa95532_1
        lz4-c                     1.9.3                h2bbff1b_1
        markdown                  3.3.4            py39haa95532_0
        matplotlib-base           3.5.0            py39h6214cd6_0
        mkl                       2021.4.0           h0e2418a_729    conda-forge
        mkl-service               2.4.0            py39h2bbff1b_0
        mkl_fft                   1.3.1            py39h277e83a_0
        mkl_random                1.2.2            py39hf11a4ad_0
        multidict                 5.1.0            py39h2bbff1b_2
        munkres                   1.1.4                      py_0
        networkx                  2.6.3              pyhd3eb1b0_0
        numpy                     1.21.2           py39hfca59bb_0
        numpy-base                1.21.2           py39h0829f74_0
        oauthlib                  3.1.1              pyhd3eb1b0_0
        olefile                   0.46               pyhd3eb1b0_0
        opencv                    4.5.1            py39hcbf5309_0    conda-forge
        openjpeg                  2.4.0                h4fc8c34_0
        openssl                   1.1.1l               h8ffe710_0    conda-forge
        opt_einsum                3.3.0              pyhd3eb1b0_1
        packaging                 21.3               pyhd3eb1b0_0
        partd                     1.2.0              pyhd3eb1b0_0
        pillow                    8.4.0            py39hd45dc43_0
        pip                       21.2.4           py39haa95532_0
        pluggy                    1.0.0            py39hcbf5309_2    conda-forge
        protobuf                  3.17.2           py39hd77b12b_0
        py                        1.11.0             pyh6c4a22f_0    conda-forge
        py-opencv                 4.5.1            py39h832f523_0    conda-forge
        pyasn1                    0.4.8              pyhd3eb1b0_0
        pyasn1-modules            0.2.8                      py_0
        pycparser                 2.21               pyhd3eb1b0_0
        pyjwt                     2.1.0            py39haa95532_0
        pyopenssl                 21.0.0             pyhd3eb1b0_1
        pyparsing                 3.0.4              pyhd3eb1b0_0
        pyreadline                2.1              py39haa95532_1
        pysocks                   1.7.1            py39haa95532_0
        pytest                    6.2.5            py39hcbf5309_2    conda-forge
        pytest-order              1.0.1              pyhd8ed1ab_0    conda-forge
        python                    3.9.7                h6244533_1
        python-dateutil           2.8.2              pyhd3eb1b0_0
        python-flatbuffers        1.12               pyhd3eb1b0_0
        python_abi                3.9                      2_cp39    conda-forge
        pywavelets                1.1.1            py39h080aedc_4
        pyyaml                    6.0              py39h2bbff1b_1
        qt                        5.12.9               h5909a2a_4    conda-forge
        requests                  2.27.1             pyhd3eb1b0_0
        requests-oauthlib         1.3.0                      py_0
        rsa                       4.7.2              pyhd3eb1b0_1
        scikit-image              0.18.3           py39hf11a4ad_0
        scipy                     1.7.3            py39h0a974cb_0
        setuptools                58.0.4           py39haa95532_0
        six                       1.16.0             pyhd3eb1b0_0
        snappy                    1.1.8                h33f27b4_0
        sqlite                    3.37.0               h2bbff1b_0
        tbb                       2021.4.0             h59b6b97_0
        tensorboard               2.6.0                      py_1
        tensorboard-data-server   0.6.0            py39haa95532_0
        tensorboard-plugin-wit    1.6.0                      py_0
        tensorflow                2.6.0           gpu_py39he88c5ba_0
        tensorflow-base           2.6.0           gpu_py39hb3da07e_0
        tensorflow-estimator      2.6.0              pyh7b7c402_0
        tensorflow-gpu            2.6.0                h17022bd_0
        termcolor                 1.1.0            py39haa95532_1
        tifffile                  2021.7.2           pyhd3eb1b0_2
        tk                        8.6.11               h2bbff1b_0
        toml                      0.10.2             pyhd8ed1ab_0    conda-forge
        toolz                     0.11.2             pyhd3eb1b0_0
        typing-extensions         3.10.0.2             hd3eb1b0_0
        typing_extensions         3.10.0.2           pyh06a4308_0
        tzdata                    2021e                hda174b7_0
        urllib3                   1.26.7             pyhd3eb1b0_0
        vc                        14.2                 h21ff451_1
        vs2015_runtime            14.27.29016          h5e58377_2
        werkzeug                  2.0.2              pyhd3eb1b0_0
        wheel                     0.35.1             pyhd3eb1b0_0
        win_inet_pton             1.1.0            py39haa95532_0
        wincertstore              0.2              py39haa95532_2
        wrapt                     1.13.3           py39h2bbff1b_2
        xz                        5.2.5                h62dcd97_0
        yaml                      0.2.5                he774522_0
        yarl                      1.6.3            py39h2bbff1b_0
        zfp                       0.5.5                hd77b12b_6
        zipp                      3.7.0              pyhd3eb1b0_0
        zlib                      1.2.11               h8cc25b3_4
        zstd                      1.4.9                h19a0ad4_0

Windows 10 conda yml install, TF 2.5
-------------------------------------

Kindly provided by Mark Aronson. See issue #10 on gitlab

Oct 28, 2021

`conda list` output::

	# packages in environment at C:\Users\SgroLab\anaconda3\envs\delta_env:
	#
	# Name                    Version                   Build  Channel
	_tflow_select             2.1.0                       gpu
	abseil-cpp                20210324.2           h0e60522_0    conda-forge
	absl-py                   0.15.0             pyhd8ed1ab_0    conda-forge
	aiohttp                   3.7.4.post0      py39hb82d6ee_0    conda-forge
	alabaster                 0.7.12                     py_0    conda-forge
	appdirs                   1.4.4              pyh9f0ad1d_0    conda-forge
	argh                      0.26.2          pyh9f0ad1d_1002    conda-forge
	arrow                     1.2.1              pyhd8ed1ab_0    conda-forge
	astor                     0.8.1              pyh9f0ad1d_0    conda-forge
	astroid                   2.6.6            py39hcbf5309_0    conda-forge
	astunparse                1.6.3              pyhd8ed1ab_0    conda-forge
	async-timeout             3.0.1                   py_1000    conda-forge
	async_generator           1.10                       py_0    conda-forge
	atomicwrites              1.4.0              pyh9f0ad1d_0    conda-forge
	attrs                     21.2.0             pyhd8ed1ab_0    conda-forge
	autopep8                  1.6.0              pyhd8ed1ab_0    conda-forge
	babel                     2.9.1              pyh44b312d_0    conda-forge
	backcall                  0.2.0              pyh9f0ad1d_0    conda-forge
	backports                 1.0                        py_2    conda-forge
	backports.functools_lru_cache 1.6.4              pyhd8ed1ab_0    conda-forge
	bcrypt                    3.2.0            py39hb82d6ee_1    conda-forge
	binaryornot               0.4.4                      py_1    conda-forge
	black                     21.9b0             pyhd8ed1ab_1    conda-forge
	bleach                    4.1.0              pyhd8ed1ab_0    conda-forge
	blinker                   1.4                        py_1    conda-forge
	blosc                     1.21.0               h0e60522_0    conda-forge
	boto3                     1.19.7                   pypi_0    pypi
	botocore                  1.22.7                   pypi_0    pypi
	brotlipy                  0.7.0           py39hb82d6ee_1001    conda-forge
	bzip2                     1.0.8                h8ffe710_4    conda-forge
	c-blosc2                  2.0.4                h09319c2_1    conda-forge
	ca-certificates           2021.10.8            h5b45459_0    conda-forge
	cached-property           1.5.2                hd8ed1ab_1    conda-forge
	cached_property           1.5.2              pyha770c72_1    conda-forge
	cachetools                4.2.4              pyhd8ed1ab_0    conda-forge
	certifi                   2021.10.8        py39hcbf5309_0    conda-forge
	cffi                      1.14.6           py39h0878f49_1    conda-forge
	cfitsio                   4.0.0                hd67004f_0    conda-forge
	chardet                   4.0.0            py39hcbf5309_1    conda-forge
	charls                    2.2.0                h39d44d4_0    conda-forge
	click                     8.0.3            py39hcbf5309_0    conda-forge
	cloudpickle               2.0.0              pyhd8ed1ab_0    conda-forge
	colorama                  0.4.4              pyh9f0ad1d_0    conda-forge
	cookiecutter              1.7.0                      py_0    conda-forge
	cryptography              35.0.0           py39h7bc7c5c_1    conda-forge
	cudatoolkit               11.3.1               h280eb24_9    conda-forge
	cudnn                     8.2.1.32             h754d62a_0    conda-forge
	cycler                    0.11.0             pyhd8ed1ab_0    conda-forge
	cytoolz                   0.11.0           py39hb82d6ee_3    conda-forge
	dask-core                 2021.10.0          pyhd8ed1ab_0    conda-forge
	dataclasses               0.8                pyhc8e2a94_3    conda-forge
	debugpy                   1.4.1            py39h415ef7b_0    conda-forge
	decorator                 5.1.0              pyhd8ed1ab_0    conda-forge
	defusedxml                0.7.1              pyhd8ed1ab_0    conda-forge
	diff-match-patch          20200713           pyh9f0ad1d_0    conda-forge
	docutils                  0.17.1           py39hcbf5309_0    conda-forge
	entrypoints               0.3             pyhd8ed1ab_1003    conda-forge
	ffmpeg                    4.3.1                ha925a31_0    conda-forge
	ffmpeg-python             0.2.0                      py_0    conda-forge
	flake8                    3.9.2              pyhd8ed1ab_0    conda-forge
	flatbuffers               2.0.0                h0e60522_0    conda-forge
	freeglut                  3.2.1                h0e60522_2    conda-forge
	freetype                  2.10.4               h546665d_1    conda-forge
	fsspec                    2021.10.1          pyhd8ed1ab_0    conda-forge
	future                    0.18.2           py39hcbf5309_3    conda-forge
	gast                      0.4.0              pyh9f0ad1d_0    conda-forge
	giflib                    5.2.1                h8d14728_2    conda-forge
	git                       2.33.1               h57928b3_0    conda-forge
	google-auth               1.35.0             pyh6c4a22f_0    conda-forge
	google-auth-oauthlib      0.4.6              pyhd8ed1ab_0    conda-forge
	google-pasta              0.2.0              pyh8c360ce_0    conda-forge
	grpcio                    1.41.1           py39hb76b349_0    conda-forge
	h5py                      3.4.0           nompi_py39hd4deaf1_101    conda-forge
	hdf5                      1.12.1          nompi_h2a0e4a3_101    conda-forge
	icu                       68.2                 h0e60522_0    conda-forge
	idna                      2.10               pyh9f0ad1d_0    conda-forge
	imagecodecs               2021.8.26        py39he391c9c_2    conda-forge
	imageio                   2.9.0                      py_0    conda-forge
	imagesize                 1.2.0                      py_0    conda-forge
	importlib-metadata        4.8.1            py39hcbf5309_0    conda-forge
	importlib_metadata        4.8.1                hd8ed1ab_0    conda-forge
	inflection                0.5.1              pyh9f0ad1d_0    conda-forge
	intel-openmp              2021.4.0          h57928b3_3556    conda-forge
	intervaltree              3.0.2                      py_0    conda-forge
	ipykernel                 6.4.2            py39h832f523_0    conda-forge
	ipython                   7.29.0           py39h832f523_0    conda-forge
	ipython_genutils          0.2.0                      py_1    conda-forge
	isort                     5.9.3              pyhd8ed1ab_0    conda-forge
	jasper                    2.0.33               h77af90b_0    conda-forge
	jbig                      2.1               h8d14728_2003    conda-forge
	jedi                      0.18.0           py39hcbf5309_2    conda-forge
	jinja2                    3.0.2              pyhd8ed1ab_0    conda-forge
	jinja2-time               0.2.0                      py_2    conda-forge
	jmespath                  0.10.0                   pypi_0    pypi
	jpeg                      9d                   h8ffe710_0    conda-forge
	jsonschema                4.1.2              pyhd8ed1ab_0    conda-forge
	jupyter_client            6.1.12             pyhd8ed1ab_0    conda-forge
	jupyter_core              4.9.1            py39hcbf5309_0    conda-forge
	jupyterlab_pygments       0.1.2              pyh9f0ad1d_0    conda-forge
	jxrlib                    1.1                  h8ffe710_2    conda-forge
	keras-preprocessing       1.1.2              pyhd8ed1ab_0    conda-forge
	keyring                   23.2.1           py39hcbf5309_0    conda-forge
	kiwisolver                1.3.2            py39h2e07f2f_0    conda-forge
	krb5                      1.19.2               hbae68bd_2    conda-forge
	lazy-object-proxy         1.6.0            py39hb82d6ee_0    conda-forge
	lcms2                     2.12                 h2a16943_0    conda-forge
	lerc                      3.0                  h0e60522_0    conda-forge
	libaec                    1.0.6                h39d44d4_0    conda-forge
	libblas                   3.9.0              12_win64_mkl    conda-forge
	libbrotlicommon           1.0.9                h8ffe710_5    conda-forge
	libbrotlidec              1.0.9                h8ffe710_5    conda-forge
	libbrotlienc              1.0.9                h8ffe710_5    conda-forge
	libcblas                  3.9.0              12_win64_mkl    conda-forge
	libclang                  11.1.0          default_h5c34c98_1    conda-forge
	libcurl                   7.79.1               h789b8ee_1    conda-forge
	libdeflate                1.8                  h8ffe710_0    conda-forge
	liblapack                 3.9.0              12_win64_mkl    conda-forge
	liblapacke                3.9.0              12_win64_mkl    conda-forge
	libopencv                 4.5.1            py39h27d8466_0    conda-forge
	libpng                    1.6.37               h1d00b33_2    conda-forge
	libprotobuf               3.14.0               h7755175_0    conda-forge
	libsodium                 1.0.18               h8d14728_1    conda-forge
	libspatialindex           1.9.3                h39d44d4_4    conda-forge
	libssh2                   1.10.0               h680486a_2    conda-forge
	libtiff                   4.3.0                hd413186_2    conda-forge
	libwebp-base              1.2.1                h8ffe710_0    conda-forge
	libzlib                   1.2.11            h8ffe710_1013    conda-forge
	libzopfli                 1.0.3                h0e60522_0    conda-forge
	locket                    0.2.0                      py_2    conda-forge
	lz4-c                     1.9.3                h8ffe710_1    conda-forge
	m2w64-gcc-libgfortran     5.3.0                         6    conda-forge
	m2w64-gcc-libs            5.3.0                         7    conda-forge
	m2w64-gcc-libs-core       5.3.0                         7    conda-forge
	m2w64-gmp                 6.1.0                         2    conda-forge
	m2w64-libwinpthread-git   5.0.0.4634.697f757               2    conda-forge
	markdown                  3.3.4              pyhd8ed1ab_0    conda-forge
	markupsafe                2.0.1            py39hb82d6ee_0    conda-forge
	matplotlib-base           3.4.3            py39h581301d_1    conda-forge
	matplotlib-inline         0.1.3              pyhd8ed1ab_0    conda-forge
	mccabe                    0.6.1                      py_1    conda-forge
	mistune                   0.8.4           py39hb82d6ee_1004    conda-forge
	mkl                       2021.4.0           h0e2418a_729    conda-forge
	msys2-conda-epoch         20160418                      1    conda-forge
	multidict                 5.2.0            py39hb82d6ee_0    conda-forge
	mypy_extensions           0.4.3            py39hcbf5309_3    conda-forge
	nbclient                  0.5.4              pyhd8ed1ab_0    conda-forge
	nbconvert                 6.2.0            py39hcbf5309_0    conda-forge
	nbformat                  5.1.3              pyhd8ed1ab_0    conda-forge
	nest-asyncio              1.5.1              pyhd8ed1ab_0    conda-forge
	networkx                  2.6.3              pyhd8ed1ab_1    conda-forge
	numpy                     1.21.3           py39h6635163_0    conda-forge
	numpydoc                  1.1.0                      py_1    conda-forge
	oauthlib                  3.1.1              pyhd8ed1ab_0    conda-forge
	olefile                   0.46               pyh9f0ad1d_1    conda-forge
	opencv                    4.5.1            py39hcbf5309_0    conda-forge
	openjpeg                  2.4.0                hb211442_1    conda-forge
	openssl                   1.1.1l               h8ffe710_0    conda-forge
	opt_einsum                3.3.0              pyhd8ed1ab_1    conda-forge
	packaging                 21.0               pyhd8ed1ab_0    conda-forge
	pandas                    1.3.4            py39h2e25243_0    conda-forge
	pandoc                    2.16                 h8ffe710_0    conda-forge
	pandocfilters             1.5.0              pyhd8ed1ab_0    conda-forge
	paramiko                  2.8.0              pyhd8ed1ab_0    conda-forge
	parso                     0.8.2              pyhd8ed1ab_0    conda-forge
	partd                     1.2.0              pyhd8ed1ab_0    conda-forge
	pathspec                  0.9.0              pyhd8ed1ab_0    conda-forge
	pexpect                   4.8.0              pyh9f0ad1d_2    conda-forge
	pickleshare               0.7.5                   py_1003    conda-forge
	pillow                    8.3.2            py39h916092e_0    conda-forge
	pip                       21.3.1             pyhd8ed1ab_0    conda-forge
	platformdirs              2.3.0              pyhd8ed1ab_0    conda-forge
	pluggy                    1.0.0            py39hcbf5309_1    conda-forge
	pooch                     1.5.2              pyhd8ed1ab_0    conda-forge
	poyo                      0.5.0                      py_0    conda-forge
	prompt-toolkit            3.0.21             pyha770c72_0    conda-forge
	protobuf                  3.14.0           py39h415ef7b_1    conda-forge
	psutil                    5.8.0            py39hb82d6ee_1    conda-forge
	ptyprocess                0.7.0              pyhd3deb0d_0    conda-forge
	py-opencv                 4.5.1            py39h832f523_0    conda-forge
	pyasn1                    0.4.8                      py_0    conda-forge
	pyasn1-modules            0.2.7                      py_0    conda-forge
	pycodestyle               2.7.0              pyhd8ed1ab_0    conda-forge
	pycparser                 2.20               pyh9f0ad1d_2    conda-forge
	pydocstyle                6.1.1              pyhd8ed1ab_0    conda-forge
	pyflakes                  2.3.1              pyhd8ed1ab_0    conda-forge
	pygments                  2.10.0             pyhd8ed1ab_0    conda-forge
	pyjwt                     2.3.0              pyhd8ed1ab_0    conda-forge
	pylint                    2.9.6              pyhd8ed1ab_0    conda-forge
	pyls-spyder               0.4.0              pyhd8ed1ab_0    conda-forge
	pynacl                    1.4.0            py39hb3671d1_2    conda-forge
	pyopenssl                 21.0.0             pyhd8ed1ab_0    conda-forge
	pyparsing                 3.0.4              pyhd8ed1ab_0    conda-forge
	pyqt                      5.12.3           py39hcbf5309_7    conda-forge
	pyqt-impl                 5.12.3           py39h415ef7b_7    conda-forge
	pyqt5-sip                 4.19.18          py39h415ef7b_7    conda-forge
	pyqtchart                 5.12             py39h415ef7b_7    conda-forge
	pyqtwebengine             5.12.1           py39h415ef7b_7    conda-forge
	pyrsistent                0.17.3           py39hb82d6ee_2    conda-forge
	pysocks                   1.7.1            py39hcbf5309_3    conda-forge
	python                    3.9.7           h7840368_3_cpython    conda-forge
	python-bioformats         4.0.5                    pypi_0    pypi
	python-dateutil           2.8.2              pyhd8ed1ab_0    conda-forge
	python-flatbuffers        1.12               pyhd8ed1ab_1    conda-forge
	python-javabridge         4.0.3                    pypi_0    pypi
	python-lsp-black          1.0.0              pyhd8ed1ab_0    conda-forge
	python-lsp-jsonrpc        1.0.0              pyhd8ed1ab_0    conda-forge
	python-lsp-server         1.2.4              pyhd8ed1ab_0    conda-forge
	python_abi                3.9                      2_cp39    conda-forge
	pytz                      2021.3             pyhd8ed1ab_0    conda-forge
	pyu2f                     0.1.5              pyhd8ed1ab_0    conda-forge
	pywavelets                1.1.1            py39h5d4886f_3    conda-forge
	pywin32                   301              py39hb82d6ee_0    conda-forge
	pywin32-ctypes            0.2.0           py39hcbf5309_1003    conda-forge
	pyyaml                    6.0              py39hb82d6ee_0    conda-forge
	pyzmq                     22.3.0           py39he46f08e_0    conda-forge
	qdarkstyle                3.0.2              pyhd8ed1ab_0    conda-forge
	qstylizer                 0.2.1              pyhd8ed1ab_0    conda-forge
	qt                        5.12.9               h5909a2a_4    conda-forge
	qtawesome                 1.0.3              pyhd8ed1ab_0    conda-forge
	qtconsole                 5.1.1              pyhd8ed1ab_0    conda-forge
	qtpy                      1.11.2             pyhd8ed1ab_0    conda-forge
	regex                     2021.10.23       py39hb82d6ee_0    conda-forge
	requests                  2.25.1             pyhd3deb0d_0    conda-forge
	requests-oauthlib         1.3.0              pyh9f0ad1d_0    conda-forge
	rope                      0.21.0             pyhd8ed1ab_0    conda-forge
	rsa                       4.7.2              pyh44b312d_0    conda-forge
	rtree                     0.9.7            py39h09fdee3_2    conda-forge
	s3transfer                0.5.0                    pypi_0    pypi
	scikit-image              0.18.3           py39h2e25243_0    conda-forge
	scipy                     1.7.1            py39hc0c34ad_0    conda-forge
	setuptools                58.3.0           py39hcbf5309_0    conda-forge
	six                       1.16.0             pyh6c4a22f_0    conda-forge
	snappy                    1.1.8                ha925a31_3    conda-forge
	snowballstemmer           2.1.0              pyhd8ed1ab_0    conda-forge
	sortedcontainers          2.4.0              pyhd8ed1ab_0    conda-forge
	sphinx                    4.2.0              pyh6c4a22f_0    conda-forge
	sphinxcontrib-applehelp   1.0.2                      py_0    conda-forge
	sphinxcontrib-devhelp     1.0.2                      py_0    conda-forge
	sphinxcontrib-htmlhelp    2.0.0              pyhd8ed1ab_0    conda-forge
	sphinxcontrib-jsmath      1.0.1                      py_0    conda-forge
	sphinxcontrib-qthelp      1.0.3                      py_0    conda-forge
	sphinxcontrib-serializinghtml 1.1.5              pyhd8ed1ab_0    conda-forge
	spyder                    5.1.5            py39hcbf5309_0    conda-forge
	spyder-kernels            2.1.3            py39hcbf5309_0    conda-forge
	sqlite                    3.36.0               h8ffe710_2    conda-forge
	tbb                       2021.4.0             h2d74725_0    conda-forge
	tensorboard               2.5.0              pyhd8ed1ab_1    conda-forge
	tensorboard-data-server   0.6.0            py39hcbf5309_0    conda-forge
	tensorboard-plugin-wit    1.8.0              pyh44b312d_0    conda-forge
	tensorflow                2.5.0           gpu_py39h7dc34a2_0
	tensorflow-base           2.5.0           gpu_py39hb3da07e_0
	tensorflow-estimator      2.5.0              pyh81a9013_1    conda-forge
	tensorflow-gpu            2.5.0                h17022bd_0
	termcolor                 1.1.0                      py_2    conda-forge
	testpath                  0.5.0              pyhd8ed1ab_0    conda-forge
	textdistance              4.2.2              pyhd8ed1ab_0    conda-forge
	three-merge               0.1.1              pyh9f0ad1d_0    conda-forge
	tifffile                  2021.10.12         pyhd8ed1ab_0    conda-forge
	tinycss2                  1.1.0              pyhd8ed1ab_0    conda-forge
	tk                        8.6.11               h8ffe710_1    conda-forge
	toml                      0.10.2             pyhd8ed1ab_0    conda-forge
	tomli                     1.2.2              pyhd8ed1ab_0    conda-forge
	toolz                     0.11.1                     py_0    conda-forge
	tornado                   6.1              py39hb82d6ee_1    conda-forge
	traitlets                 5.1.1              pyhd8ed1ab_0    conda-forge
	typed-ast                 1.4.3            py39hb82d6ee_0    conda-forge
	typing-extensions         3.10.0.2             hd8ed1ab_0    conda-forge
	typing_extensions         3.10.0.2           pyha770c72_0    conda-forge
	tzdata                    2021e                he74cb21_0    conda-forge
	ucrt                      10.0.20348.0         h57928b3_0    conda-forge
	ujson                     4.2.0            py39h415ef7b_0    conda-forge
	urllib3                   1.26.7             pyhd8ed1ab_0    conda-forge
	vc                        14.2                 hb210afc_5    conda-forge
	vs2015_runtime            14.29.30037          h902a5da_5    conda-forge
	watchdog                  2.1.6            py39hcbf5309_0    conda-forge
	wcwidth                   0.2.5              pyh9f0ad1d_2    conda-forge
	webencodings              0.5.1                      py_1    conda-forge
	werkzeug                  2.0.1              pyhd8ed1ab_0    conda-forge
	wheel                     0.35.1             pyh9f0ad1d_0    conda-forge
	whichcraft                0.6.1                      py_0    conda-forge
	win_inet_pton             1.1.0            py39hcbf5309_2    conda-forge
	wrapt                     1.12.1           py39hb82d6ee_3    conda-forge
	xz                        5.2.5                h62dcd97_1    conda-forge
	yaml                      0.2.5                he774522_0    conda-forge
	yapf                      0.31.0             pyhd8ed1ab_0    conda-forge
	yarl                      1.7.0            py39hb82d6ee_0    conda-forge
	zeromq                    4.3.4                h0e60522_1    conda-forge
	zfp                       0.5.5                h0e60522_7    conda-forge
	zipp                      3.6.0              pyhd8ed1ab_0    conda-forge
	zlib                      1.2.11            h8ffe710_1013    conda-forge
	zstd                      1.5.0                h6255e5f_0    conda-forge
	
Windows 10 conda yml install, TF 2.3
--------------------------------------

install date: End of 2020	

`conda list` output::

	# packages in environment at C:\Users\jeanbaptiste\Anaconda3\envs\delta_env:
	#
	# Name                    Version                   Build  Channel
	_tflow_select             2.3.0                       gpu
	absl-py                   0.12.0             pyhd8ed1ab_0    conda-forge
	aiohttp                   3.7.4            py38h294d835_0    conda-forge
	alabaster                 0.7.12                     py_0    conda-forge
	appdirs                   1.4.4              pyh9f0ad1d_0    conda-forge
	argh                      0.26.2          pyh9f0ad1d_1002    conda-forge
	arrow                     0.13.1                   py38_0
	astor                     0.8.1              pyh9f0ad1d_0    conda-forge
	astroid                   2.5.1            py38haa244fe_0    conda-forge
	astunparse                1.6.3              pyhd8ed1ab_0    conda-forge
	async-timeout             3.0.1                   py_1000    conda-forge
	async_generator           1.10                       py_0    conda-forge
	atomicwrites              1.4.0              pyh9f0ad1d_0    conda-forge
	attrs                     20.3.0             pyhd3deb0d_0    conda-forge
	autopep8                  1.5.6              pyhd8ed1ab_0    conda-forge
	babel                     2.9.0              pyhd3deb0d_0    conda-forge
	backcall                  0.2.0              pyh9f0ad1d_0    conda-forge
	backports                 1.0                        py_2    conda-forge
	backports.functools_lru_cache 1.6.1                      py_0    conda-forge
	bcrypt                    3.2.0            py38h294d835_1    conda-forge
	binaryornot               0.4.4              pyhd3eb1b0_1
	black                     20.8b1                     py_1    conda-forge
	bleach                    3.3.0              pyh44b312d_0    conda-forge
	blinker                   1.4                        py_1    conda-forge
	blosc                     1.21.0               h0e60522_0    conda-forge
	boto3                     1.17.35                  pypi_0    pypi
	botocore                  1.20.35                  pypi_0    pypi
	brotli                    1.0.9                h0e60522_4    conda-forge
	brotlipy                  0.7.0           py38h294d835_1001    conda-forge
	bzip2                     1.0.8                h8ffe710_4    conda-forge
	ca-certificates           2021.7.5             haa95532_1
	cachetools                4.2.1              pyhd8ed1ab_0    conda-forge
	certifi                   2021.5.30        py38haa95532_0
	cffi                      1.14.5           py38hd8c33c5_0    conda-forge
	chardet                   4.0.0            py38haa244fe_1    conda-forge
	charls                    2.2.0                h39d44d4_0    conda-forge
	click                     7.1.2              pyh9f0ad1d_0    conda-forge
	cloudpickle               1.6.0                      py_0    conda-forge
	colorama                  0.4.4              pyh9f0ad1d_0    conda-forge
	cookiecutter              1.7.2              pyhd3eb1b0_0
	cryptography              3.4.6            py38hd7da0ea_0    conda-forge
	cudatoolkit               10.1.243             h3826478_8    conda-forge
	cudnn                     7.6.5.32             h36d860d_1    conda-forge
	cycler                    0.10.0                     py_2    conda-forge
	cytoolz                   0.11.0           py38h294d835_3    conda-forge
	dask-core                 2021.3.0           pyhd8ed1ab_0    conda-forge
	dataclasses               0.8                pyhc8e2a94_1    conda-forge
	decorator                 4.4.2                      py_0    conda-forge
	defusedxml                0.7.1              pyhd8ed1ab_0    conda-forge
	diff-match-patch          20200713           pyh9f0ad1d_0    conda-forge
	docutils                  0.16             py38haa244fe_3    conda-forge
	elasticdeform             0.4.9                    pypi_0    pypi
	entrypoints               0.3             pyhd8ed1ab_1003    conda-forge
	ffmpeg                    4.2.2                he774522_0
	ffmpeg-python             0.2.0                      py_0    conda-forge
	flake8                    3.8.4                      py_0    conda-forge
	freeglut                  3.2.1                h0e60522_2    conda-forge
	freetype                  2.10.4               h546665d_1    conda-forge
	future                    0.18.2           py38haa244fe_3    conda-forge
	gast                      0.4.0              pyh9f0ad1d_0    conda-forge
	giflib                    5.2.1                h8d14728_2    conda-forge
	git                       2.30.2               h57928b3_0    conda-forge
	google-auth               1.24.0             pyhd3deb0d_0    conda-forge
	google-auth-oauthlib      0.4.1                      py_2    conda-forge
	google-pasta              0.2.0              pyh8c360ce_0    conda-forge
	grpcio                    1.36.1           py38he5377a8_0    conda-forge
	h5py                      2.10.0          nompi_py38h6053941_105    conda-forge
	hdf5                      1.10.6          nompi_h5268f04_1114    conda-forge
	helpdev                   0.7.1              pyhd8ed1ab_0    conda-forge
	icu                       68.1                 h0e60522_0    conda-forge
	idna                      2.10               pyh9f0ad1d_0    conda-forge
	imagecodecs               2021.1.28        py38hb9201fa_0    conda-forge
	imageio                   2.9.0                      py_0    conda-forge
	imagesize                 1.2.0                      py_0    conda-forge
	importlib-metadata        3.7.3            py38haa244fe_0    conda-forge
	importlib_metadata        3.7.3                hd8ed1ab_0    conda-forge
	inflection                0.5.1            py38haa95532_0
	intel-openmp              2020.3             h57928b3_311    conda-forge
	intervaltree              3.0.2                      py_0    conda-forge
	ipykernel                 5.5.0            py38hc5df569_1    conda-forge
	ipython                   7.21.0           py38hc5df569_0    conda-forge
	ipython_genutils          0.2.0                      py_1    conda-forge
	isort                     5.8.0              pyhd8ed1ab_0    conda-forge
	jasper                    2.0.14               h77af90b_2    conda-forge
	jedi                      0.17.2           py38haa244fe_1    conda-forge
	jinja2                    2.11.3             pyh44b312d_0    conda-forge
	jinja2-time               0.2.0              pyhd3eb1b0_2
	jmespath                  0.10.0                   pypi_0    pypi
	jpeg                      9d                   h8ffe710_0    conda-forge
	jsonschema                3.2.0              pyhd8ed1ab_3    conda-forge
	jupyter_client            6.1.12             pyhd8ed1ab_0    conda-forge
	jupyter_core              4.7.1            py38haa244fe_0    conda-forge
	jupyterlab_pygments       0.1.2              pyh9f0ad1d_0    conda-forge
	jxrlib                    1.1                  h8ffe710_2    conda-forge
	keras-applications        1.0.8                      py_1    conda-forge
	keras-preprocessing       1.1.2              pyhd8ed1ab_0    conda-forge
	keyring                   23.0.0           py38haa244fe_0    conda-forge
	kiwisolver                1.3.1            py38hbd9d945_1    conda-forge
	krb5                      1.17.2               hbae68bd_0    conda-forge
	lazy-object-proxy         1.6.0            py38h294d835_0    conda-forge
	lcms2                     2.12                 h2a16943_0    conda-forge
	lerc                      2.2.1                h0e60522_0    conda-forge
	libaec                    1.0.4                h39d44d4_1    conda-forge
	libblas                   3.9.0                     8_mkl    conda-forge
	libcblas                  3.9.0                     8_mkl    conda-forge
	libclang                  11.1.0          default_h5c34c98_0    conda-forge
	libcurl                   7.75.0               hf1763fc_0    conda-forge
	libdeflate                1.7                  h8ffe710_5    conda-forge
	liblapack                 3.9.0                     8_mkl    conda-forge
	liblapacke                3.9.0                     8_mkl    conda-forge
	libopencv                 4.5.1            py38hf7032e7_0    conda-forge
	libpng                    1.6.37               h1d00b33_2    conda-forge
	libprotobuf               3.15.6               h7755175_0    conda-forge
	libsodium                 1.0.18               h8d14728_1    conda-forge
	libspatialindex           1.9.3                h39d44d4_3    conda-forge
	libssh2                   1.9.0                h680486a_6    conda-forge
	libtiff                   4.2.0                hc10be44_0    conda-forge
	libwebp-base              1.2.0                h8ffe710_2    conda-forge
	libzopfli                 1.0.3                h0e60522_0    conda-forge
	lz4-c                     1.9.3                h8ffe710_0    conda-forge
	m2w64-gcc-libgfortran     5.3.0                         6    conda-forge
	m2w64-gcc-libs            5.3.0                         7    conda-forge
	m2w64-gcc-libs-core       5.3.0                         7    conda-forge
	m2w64-gmp                 6.1.0                         2    conda-forge
	m2w64-libwinpthread-git   5.0.0.4634.697f757               2    conda-forge
	markdown                  3.3.4              pyhd8ed1ab_0    conda-forge
	markupsafe                1.1.1            py38h294d835_3    conda-forge
	matplotlib-base           3.3.4            py38h34ddff4_0    conda-forge
	mccabe                    0.6.1                      py_1    conda-forge
	mistune                   0.8.4           py38h294d835_1003    conda-forge
	mkl                       2020.4             hb70f87d_311    conda-forge
	msys2-conda-epoch         20160418                      1    conda-forge
	multidict                 5.1.0            py38h294d835_1    conda-forge
	mypy_extensions           0.4.3            py38haa244fe_3    conda-forge
	nbclient                  0.5.3              pyhd8ed1ab_0    conda-forge
	nbconvert                 6.0.7            py38haa244fe_3    conda-forge
	nbformat                  5.1.2              pyhd8ed1ab_1    conda-forge
	nest-asyncio              1.4.3              pyhd8ed1ab_0    conda-forge
	networkx                  2.5                        py_0    conda-forge
	numpy                     1.20.1           py38h0cc643e_0    conda-forge
	numpydoc                  1.1.0                      py_1    conda-forge
	oauthlib                  3.0.1                      py_0    conda-forge
	olefile                   0.46               pyh9f0ad1d_1    conda-forge
	opencv                    4.5.1            py38haa244fe_0    conda-forge
	openjpeg                  2.4.0                h48faf41_0    conda-forge
	openssl                   1.1.1l               h2bbff1b_0
	opt_einsum                3.3.0                      py_0    conda-forge
	packaging                 20.9               pyh44b312d_0    conda-forge
	pandoc                    2.13                 h8ffe710_0    conda-forge
	pandocfilters             1.4.2                      py_1    conda-forge
	paramiko                  2.7.2              pyh9f0ad1d_0    conda-forge
	parso                     0.7.0              pyh9f0ad1d_0    conda-forge
	pathspec                  0.8.1              pyhd3deb0d_0    conda-forge
	pexpect                   4.8.0              pyh9f0ad1d_2    conda-forge
	pickleshare               0.7.5                   py_1003    conda-forge
	pillow                    8.1.2            py38h9273828_0    conda-forge
	pip                       21.0.1             pyhd8ed1ab_0    conda-forge
	pluggy                    0.13.1           py38haa244fe_4    conda-forge
	pooch                     1.3.0              pyhd8ed1ab_0    conda-forge
	poyo                      0.5.0              pyhd3eb1b0_0
	prompt-toolkit            3.0.18             pyha770c72_0    conda-forge
	protobuf                  3.15.6           py38h885f38d_0    conda-forge
	psutil                    5.8.0            py38h294d835_1    conda-forge
	ptyprocess                0.7.0              pyhd3deb0d_0    conda-forge
	py-opencv                 4.5.1            py38hc5df569_0    conda-forge
	pyasn1                    0.4.8                      py_0    conda-forge
	pyasn1-modules            0.2.7                      py_0    conda-forge
	pycodestyle               2.6.0              pyh9f0ad1d_0    conda-forge
	pycparser                 2.20               pyh9f0ad1d_2    conda-forge
	pydocstyle                6.0.0              pyhd8ed1ab_0    conda-forge
	pyflakes                  2.2.0              pyh9f0ad1d_0    conda-forge
	pygments                  2.8.1              pyhd8ed1ab_0    conda-forge
	pyjwt                     2.0.1              pyhd8ed1ab_0    conda-forge
	pylint                    2.7.2            py38haa244fe_0    conda-forge
	pyls-black                0.4.6              pyh9f0ad1d_0    conda-forge
	pyls-spyder               0.3.2              pyhd8ed1ab_0    conda-forge
	pynacl                    1.4.0            py38h31c79cd_2    conda-forge
	pyopenssl                 20.0.1             pyhd8ed1ab_0    conda-forge
	pyparsing                 2.4.7              pyh9f0ad1d_0    conda-forge
	pyqt                      5.12.3           py38haa244fe_7    conda-forge
	pyqt-impl                 5.12.3           py38h885f38d_7    conda-forge
	pyqt5-sip                 4.19.18          py38h885f38d_7    conda-forge
	pyqtchart                 5.12             py38h885f38d_7    conda-forge
	pyqtwebengine             5.12.1           py38h885f38d_7    conda-forge
	pyreadline                2.1             py38haa244fe_1003    conda-forge
	pyrsistent                0.17.3           py38h294d835_2    conda-forge
	pysocks                   1.7.1            py38haa244fe_3    conda-forge
	python                    3.8.8           h7840368_0_cpython    conda-forge
	python-bioformats         4.0.4                    pypi_0    pypi
	python-dateutil           2.8.1                      py_0    conda-forge
	python-javabridge         4.0.3                    pypi_0    pypi
	python-jsonrpc-server     0.4.0              pyh9f0ad1d_0    conda-forge
	python-language-server    0.36.2             pyhd8ed1ab_0    conda-forge
	python-slugify            5.0.2              pyhd3eb1b0_0
	python_abi                3.8                      1_cp38    conda-forge
	pytz                      2021.1             pyhd8ed1ab_0    conda-forge
	pywavelets                1.1.1            py38h347fdf6_3    conda-forge
	pywin32                   300              py38h294d835_0    conda-forge
	pywin32-ctypes            0.2.0           py38haa244fe_1003    conda-forge
	pyyaml                    5.4.1            py38h294d835_0    conda-forge
	pyzmq                     22.0.3           py38h09162b1_1    conda-forge
	qdarkstyle                3.0.2              pyhd3eb1b0_0
	qstylizer                 0.1.10             pyhd3eb1b0_0
	qt                        5.12.9               h5909a2a_4    conda-forge
	qtawesome                 1.0.2              pyhd8ed1ab_0    conda-forge
	qtconsole                 5.0.3              pyhd8ed1ab_0    conda-forge
	qtpy                      1.9.0                      py_0    conda-forge
	regex                     2021.3.17        py38h294d835_0    conda-forge
	requests                  2.25.1             pyhd3deb0d_0    conda-forge
	requests-oauthlib         1.3.0              pyh9f0ad1d_0    conda-forge
	rope                      0.18.0             pyh9f0ad1d_0    conda-forge
	rsa                       4.7.2              pyh44b312d_0    conda-forge
	rtree                     0.9.7            py38h8b54edf_1    conda-forge
	s3transfer                0.3.6                    pypi_0    pypi
	scikit-image              0.18.1           py38h4c96930_0    conda-forge
	scipy                     1.6.1            py38h5f893b4_0    conda-forge
	setuptools                49.6.0           py38haa244fe_3    conda-forge
	six                       1.15.0             pyh9f0ad1d_0    conda-forge
	snappy                    1.1.8                ha925a31_3    conda-forge
	snowballstemmer           2.1.0              pyhd8ed1ab_0    conda-forge
	sortedcontainers          2.3.0              pyhd8ed1ab_0    conda-forge
	sphinx                    3.5.3              pyhd8ed1ab_0    conda-forge
	sphinxcontrib-applehelp   1.0.2                      py_0    conda-forge
	sphinxcontrib-devhelp     1.0.2                      py_0    conda-forge
	sphinxcontrib-htmlhelp    1.0.3                      py_0    conda-forge
	sphinxcontrib-jsmath      1.0.1                      py_0    conda-forge
	sphinxcontrib-qthelp      1.0.3                      py_0    conda-forge
	sphinxcontrib-serializinghtml 1.1.4                      py_0    conda-forge
	spyder                    5.0.0            py38haa95532_1
	spyder-kernels            2.0.5            py38haa95532_0
	sqlite                    3.35.2               h8ffe710_0    conda-forge
	tensorboard               2.4.1              pyhd8ed1ab_0    conda-forge
	tensorboard-plugin-wit    1.8.0              pyh44b312d_0    conda-forge
	tensorflow                2.3.0           mkl_py38h1fcfbd6_0
	tensorflow-base           2.3.0           gpu_py38h7339f5a_0
	tensorflow-estimator      2.4.0              pyh9656e83_0    conda-forge
	tensorflow-gpu            2.3.0                he13fc11_0
	termcolor                 1.1.0                      py_2    conda-forge
	testpath                  0.4.4                      py_0    conda-forge
	text-unidecode            1.3                pyhd3eb1b0_0
	textdistance              4.2.1              pyhd8ed1ab_0    conda-forge
	three-merge               0.1.1              pyh9f0ad1d_0    conda-forge
	tifffile                  2021.3.17          pyhd8ed1ab_0    conda-forge
	tinycss                   0.4             pyhd3eb1b0_1002
	tk                        8.6.10               h8ffe710_1    conda-forge
	toml                      0.10.2             pyhd8ed1ab_0    conda-forge
	toolz                     0.11.1                     py_0    conda-forge
	tornado                   6.1              py38h294d835_1    conda-forge
	traitlets                 5.0.5                      py_0    conda-forge
	typed-ast                 1.4.2            py38h294d835_0    conda-forge
	typing-extensions         3.7.4.3                       0    conda-forge
	typing_extensions         3.7.4.3                    py_0    conda-forge
	ujson                     4.0.2            py38h885f38d_0    conda-forge
	unidecode                 1.2.0              pyhd3eb1b0_0
	urllib3                   1.26.4             pyhd8ed1ab_0    conda-forge
	vc                        14.2                 hb210afc_4    conda-forge
	vs2015_runtime            14.28.29325          h5e1d092_4    conda-forge
	watchdog                  1.0.2            py38haa244fe_1    conda-forge
	wcwidth                   0.2.5              pyh9f0ad1d_2    conda-forge
	webencodings              0.5.1                      py_1    conda-forge
	werkzeug                  1.0.1              pyh9f0ad1d_0    conda-forge
	wheel                     0.36.2             pyhd3deb0d_0    conda-forge
	whichcraft                0.6.1              pyhd3eb1b0_0
	win_inet_pton             1.1.0            py38haa244fe_2    conda-forge
	wincertstore              0.2             py38haa244fe_1006    conda-forge
	wrapt                     1.12.1           py38h294d835_3    conda-forge
	xz                        5.2.5                h62dcd97_1    conda-forge
	yaml                      0.2.5                he774522_0    conda-forge
	yapf                      0.30.0             pyh9f0ad1d_0    conda-forge
	yarl                      1.6.3            py38h294d835_1    conda-forge
	zeromq                    4.3.4                h0e60522_0    conda-forge
	zfp                       0.5.5                h0e60522_4    conda-forge
	zipp                      3.4.1              pyhd8ed1ab_0    conda-forge
	zlib                      1.2.11            h62dcd97_1010    conda-forge
	zstd                      1.4.9                h6255e5f_0    conda-forge

