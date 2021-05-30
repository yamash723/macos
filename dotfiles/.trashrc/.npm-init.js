function repositoryMeta(provider, user, repo) {
  if (provider === 'github.com' || provider === 'gitlab.com') {
    const homepage = `https://${provider}/${user}/${repo}`;
    return {
      bugs: {
        url: `${homepage}/issues`
      },
      homepage,
      repository: `${provider.replace(/\.com$/, '')}:${user}/${repo}`
    };
  }
  return null;
}

const cwdTree = process.cwd().split('/');
const repo = cwdTree.pop();
const user = cwdTree.pop();
const provider = cwdTree.pop();
const meta = repositoryMeta(provider, user, repo);

const json = {
  name: repo,
  description: '',
  version: '0.1.0',
  author: 'ulwlu <ooulwluoo@gmail.com> (https://ulwlu.netlify.app)'
};

if (meta) {
  json.bugs = meta.bugs;
  json.homepage = meta.homepage;
}

json.keywords = [];
json.license = 'MIT';
json.main = '';
json.private = true;

if (meta) {
  json.repository = meta.repository;
}

json.scripts = {
  "eslint": "eslint --fix 'src/**/*.ts'",
  "stylelint": "stylelint --fix 'src/**/*.scss'",
  "format": "npm run eslint && npm run stylelint",
  "typecheck": "tsc -w",
  "json-server": "npx json-server --watch db.json --port 3001",
  "webpack-server": "npx webpack-dev-server --env.file=development --config webpack/dev.js",
  "dev": "npm run json-server & npm run webpack-server",
  "build:development": "npx webpack --env.file=development --config webpack/dev.js",
  "build:production": "npx webpack --env.file=production --config webpack/prod.js"
};

module.exports = json;
