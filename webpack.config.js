var path = require('path');

module.exports = {
  context: __dirname,
  entry: "./frontend/minesweeper.jsx",
  output: {
    path: "./app/assets/",
    filename: "bundle.js"
  },
  module: {
    loaders: [
      {
        test: /\.jsx?$/,
        exclude: /node_modules/,
        loader: 'babel',
        query: {
          presets: ['react']
        }
      }
    ]
  },
  devtool: 'source-maps',
  resolve: {
    extensions: ["", ".js", '.jsx'],
    root: [path.resolve("./frontend/components")]
  }
};
