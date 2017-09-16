// @flow

import React from 'react'

import { NativeModules, NativeEventEmitter } from 'react-native';

const BlueBar = NativeModules.BlueBar
const BlueBarEmitter = new NativeEventEmitter(BlueBar);

export default class Beacons extends React.Component {
  state = {
    beacons: [],
  };
  unlisten = () => {};

  componentDidMount() {
    BlueBar.start_listening_to_uuid(this.props.uuid);
    const x = BlueBarEmitter.addListener('beacons_did_range', data => {
      this.setState({ beacons: data.beacons });
    });
    this.unlisten = () => {
      x.remove();
    };
  }

  componentWillUnmount() {
    this.unlisten();
  }

  render() {
    return this.props.children(this.state.beacons);
  }
}
