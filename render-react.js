const modulePath = process.argv[2];
const containerID = process.argv[3];


const ReactDOMServer = require('react-dom/server');
const React = require('react');
const { Component } = require(modulePath);


const el = React.createElement(Component, {});
const renderedHTML = ReactDOMServer.renderToString(el);

console.log(`<div id="${containerID}">${renderedHTML}</div>`);