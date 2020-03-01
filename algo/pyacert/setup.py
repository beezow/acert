from distutils.core import setup
setup(
  name = 'pyacert',         # How you named your package folder (MyLib)
  packages = ['PYACERT'],   # Chose the same as "name"
  version = '0.1',      # Start with a small number and increase it with every change you make
  license='University of Illinois/NCSA Open Source License',        # Chose a license from here: https://help.github.com/articles/licensing-a-repository
  description = 'Acert is an open source hashing plugin to combat social media disinformation.',   # Give a short description about your library
  author = 'Drew Zoghby',                   # Type in your name
  author_email = 'zbeezow@gmail.com',      # Type in your E-Mail
  url = 'https://github.com/beezow/acert',   # Provide either the link to your github or to your website
  download_url = 'https://github.com/beezow/acert/archive/v_01.tar.gz',    # I explain this later on
  keywords = ['HASH', 'SECURITY', 'CRYPTO'],   # Keywords that define your package best
  install_requires=[            # I get to this in a second
          'validators',
          'beautifulsoup4',
      ],
  classifiers=[
    'Development Status :: 3 - Alpha',      # Chose either "3 - Alpha", "4 - Beta" or "5 - Production/Stable" as the current state of your package
    'Intended Audience :: Developers',      # Define that your audience are developers
    'Topic :: Software Development :: Build Tools',
    'License :: OSI Approved :: University of Illinois/NCSA Open Source License',   # Again, pick a license
    'Programming Language :: Python :: 3',      #Specify which pyhton versions that you want to support
    'Programming Language :: Python :: 3.4',
    'Programming Language :: Python :: 3.5',
    'Programming Language :: Python :: 3.6',
    'Programming Language :: Python :: 3.7',
    'Programming Language :: Python :: 3.8',
  ],
)
