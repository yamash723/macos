const path = require('path');
const { merge } = require('webpack-merge');
const commonConfig = require('./webpack.common.js');
const HtmlWebpackPlugin = require('html-webpack-plugin');

const outputFile = '[name]';
const assetFile = '[name]';
const assetPath = '/';

module.exports = (env) => {
  const envFilePath = env ? `./env/.${env.file}` : './env/.development';

  const createHtmlPlugins = (entry) => {
    const htmpPlugins = [];
    Object.keys(entry).forEach((key) => {
      htmpPlugins.push(
        new HtmlWebpackPlugin({
          template: path.resolve(__dirname, `../src/pages/${key}.html`),
          filename: `${key}.html`,
          inject: 'body',
          chunks: [key],
        })
     );
    });
    return htmpPlugins;
  };
  return merge(
    commonConfig({ outputFile, assetFile, envFilePath, assetPath }),
    {
      mode: 'development',
      devtool: 'inline-source-map',
      plugins: createHtmlPlugins(
        commonConfig({ outputFile, assetFile, envFilePath, assetPath }).entry
      ),
      devServer: {
        contentBase: path.join(__dirname, 'dist'),
        open: "Google Chrome",
        host: 'localhost',
        compress: true,
        watchOptions: {
          ignored: /node_modules/,
        },
      },
    }
  );
};
