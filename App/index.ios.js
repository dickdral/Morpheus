/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
  AppRegistry,
  Text,
  View,
  Linking,
  TouchableOpacity,
  Alert,
  Dimensions,
  ScrollView,
  TouchableWithoutFeedback,
  Animated,
} from 'react-native';
import Icon from 'react-native-vector-icons/FontAwesome';
import { uniqBy } from 'lodash';

import Animation from './Animation';
import Beacons from './Beacons';
import Touchable from './Touchable';

const Bold = ({ children, style }: { children: React.Element<*>, style?: any }) => {
  return <Text style={[{ fontWeight: 'bold' }, style]} children={children} />
}

const BeaconInspector = () => {
  return (
    <Beacons uuid="0d60a289-2039-4421-9821-6b12c4274890">{beacons =>
      <View style={{ zIndex: 10, position: 'absolute', top: 0, left: 0, right: 0, backgroundColor: '#eee' }}>
        {beacons.map((beacon, i) =>
          <View key={i} style={{ padding: 20, paddingBottom: 10 }}>
            <Bold>{beacon.uuid}</Bold>
            <Text><Bold>Major: </Bold>{beacon.major}</Text>
            <Text><Bold>Minor: </Bold>{beacon.minor}</Text>
            <Text><Bold>Proximity: </Bold>{beacon.proximity}</Text>
          </View>
        )}
      </View>
    }</Beacons>
  );
}

class DelayChange extends React.Component {
  state = {
    value: this.props.value,
  }
  timeout: number;

  componentWillReceiveProps(nextProps) {
    if (nextProps.value !== this.props.value) {
      clearTimeout(this.timeout);
      this.timeout = setTimeout(() => {
        this.setState({ value: nextProps.value });
      }, this.props.seconds * 1000);
    }
  }

  render() {
    return this.props.children(this.state.value);
  }
}

class Fetch extends React.Component {
  async fetch(url) {
    const response = await fetch(this.props.url);
    const data = await response.json();
    this.props.onResponse(data);
  }

  componentDidMount() {
    this.fetch();
  }

  componentDidUpdate(prevProps) {
    if (prevProps.url !== this.props.url) {
      this.fetch();
    }
  }

  render() {
    return null;
  }
}

const ActiveBeacon = ({ children }) => {
  return (
    <Beacons uuid="0d60a289-2039-4421-9821-6b12c4274890">{beacons => {
      const close_enough = beacons
        .filter(beacon => beacon.proximity[0] > 0)
      const first = close_enough[0];

      // TODO Check if there are multiple beacons with same proximity,
      // if so decline them all!!!

      return <DelayChange seconds={3} value={first ? first.major : -1} children={children} />;
    }}</Beacons>
  )
}

const window_width = Dimensions.get('window').width;
const block_width = (window_width - (20 * 3)) / 2;

class Interval extends React.Component {
  state = {
    last_tick: Date.now(),
  }
  unlisten = () => {};

  componentDidMount() {
    const interval = setInterval(() => {
      this.setState({ last_tick: Date.now() });
    }, this.props.seconds * 1000);
    this.unlisten = () => {
      clearInterval(interval);
    };
  }

  componentWillUnmount() {
    this.unlisten();
  }

  render() {
    console.log('this.state.last_tick:', this.state.last_tick)
    return this.props.children(this.state.last_tick)
  }
}

const Location_Title = ({ item }) =>
  <View style={{ alignSelf: 'center', paddingBottom: 10, paddingTop: 10, flexDirection: 'row', alignItems: 'center' }}>
    {item.location_icon &&
      <Icon
        size={30}
        color={item.location_color}
        name={item.location_icon.replace(/fa-/, '')}
        style={{ marginRight: 10 }}
      />
    }
    <Bold
      style={{
        fontSize: 40,
        color: item.location_color,
      }}
    >{item.location}</Bold>
  </View>

type TPage =
  | { type: 'selector' }
  | { type: 'auto_menu' }
  | { type: 'force_menu', major_id: string }

export default class ibeacon extends Component {
  state=  {
    items: [],
    page: ({ type: 'auto_menu' }: TPage),
  }

  render() {
    const { items, page } = this.state;

    if (page.type === 'selector') {
      return (
        <ScrollView style={{ flex: 1 }}>
          <Interval seconds={5}>{timestamp =>
            <Fetch
              url={`https://www.speech2form.com/ords/adm/lbm/locationmenulist/dick#timestamp=${timestamp}`}
              onResponse={data => {
                this.setState({ items: data.items });
              }}
            />
          }</Interval>

          <View style={{ height: 20 }} />

          <Touchable
            onPress={() => this.setState({ page: { type: 'auto_menu' } })}
          >
            <Location_Title item={{ location: 'Auto', location_icon: 'magic', location_color: 'red' }} />

            <View
              style={{
                backgroundColor: '#eee',
                width: '80%',
                alignSelf: 'center',
                height: 1,
              }}
            />
          </Touchable>

          {uniqBy(items, x => x.location).map((item, i) =>
            <Touchable
              key={i}
              onPress={() => this.setState({ page: { type: 'force_menu', major_id: item.major_id } })}
            >
              <Location_Title item={item} />

              <View
                style={{
                  backgroundColor: '#eee',
                  width: '80%',
                  alignSelf: 'center',
                  height: 1,
                }}
              />
            </Touchable>
          )}
        </ScrollView>
      )
    }

    if (page.type === 'force_menu') {
      const matching_items = items.filter(x => x.major_id === page.major_id);
      const first_match = matching_items[0];

      if (first_match == null)
        return <View><Text>WTF</Text></View>

      return (
        <View style={{ flex: 1 }}>
          {/* <BeaconInspector /> */}

          <Interval seconds={5}>{timestamp =>
            <Fetch
              url={`https://www.speech2form.com/ords/adm/lbm/locationmenulist/dick#timestamp=${timestamp}`}
              onResponse={data => {
                this.setState({ items: data.items });
              }}
            />
          }</Interval>

          <View style={{ height: 20 }} />

          <View style={{ alignSelf: 'stretch', flex: 1 }}>
            <View>
              <Touchable
                onPress={() => this.setState({ page: { type: 'selector' } })}
              >
                <Location_Title item={first_match} />
              </Touchable>

              <ScrollView
                contentContainerStyle={{ flexDirection: 'row', flexWrap: 'wrap' }}
              >
                {matching_items.map((menu_item, i) =>
                  <Touchable
                    key={i}
                    style={{
                      borderRadius: 3,
                      width: block_width,
                      height: block_width,
                      marginLeft: 20,
                      alignItems: 'center',
                      justifyContent: 'space-between',
                      padding: 20,
                      backgroundColor: menu_item.location_color,
                      marginBottom: 20,
                    }}
                    onPress={() => {
                      Linking.openURL(menu_item.option_target)
                      .catch(err => {
                        Alert.alert(`You don't have the necessary app installed`);
                      });
                    }}
                  >
                    <View style={{ flex: 1, justifyContent: 'center' }}>
                      <Icon
                        style={{ color: 'white' }}
                        name={menu_item.option_icon.replace(/fa-/, '')}
                        size={80}
                      />
                    </View>

                    <Text
                      style={{
                        color: 'white',
                        fontWeight: 'bold',
                      }}
                    >{menu_item.option_text}</Text>
                  </Touchable>
                )}
              </ScrollView>
            </View>
          </View>
        </View>
      );
    }

    return (
      <View style={{ flex: 1 }}>
        {/* <BeaconInspector /> */}

        <Interval seconds={5}>{timestamp =>
          <Fetch
            url={`https://www.speech2form.com/ords/adm/lbm/locationmenulist/dick#timestamp=${timestamp}`}
            onResponse={data => {
              this.setState({ items: data.items });
            }}
          />
        }</Interval>

        <View style={{ height: 20 }} />

        <View style={{ alignSelf: 'stretch', flex: 1 }}>
          <ActiveBeacon>{(major_id) => {
            const matching_items = items.filter(x => x.major_id === major_id);
            const first_match = matching_items[0];

            if (first_match == null)
              return <View />

            return (
              <View>
                <Touchable
                  onPress={() => this.setState({ page: { type: 'selector' } })}
                >
                  <Location_Title item={first_match} />
                </Touchable>

                <ScrollView
                  contentContainerStyle={{ flexDirection: 'row', flexWrap: 'wrap' }}
                >
                  {matching_items.map((menu_item, i) =>
                    <Touchable
                      key={i}
                      style={{
                        borderRadius: 3,
                        width: block_width,
                        height: block_width,
                        marginLeft: 20,
                        alignItems: 'center',
                        justifyContent: 'space-between',
                        padding: 20,
                        backgroundColor: menu_item.location_color,
                        marginBottom: 20,
                      }}
                      onPress={() => {
                        Linking.openURL(menu_item.option_target)
                        .catch(err => {
                          Alert.alert(`You don't have the necessary app installed`);
                        });
                      }}
                    >
                      <View style={{ flex: 1, justifyContent: 'center' }}>
                        <Icon
                          style={{ color: 'white' }}
                          name={menu_item.option_icon.replace(/fa-/, '')}
                          size={80}
                        />
                      </View>

                      <Text
                        style={{
                          color: 'white',
                          fontWeight: 'bold',
                        }}
                      >{menu_item.option_text}</Text>
                    </Touchable>
                  )}
                </ScrollView>
              </View>
            )

          }}</ActiveBeacon>
        </View>
      </View>
    );
  }
}

AppRegistry.registerComponent('ibeacon', () => ibeacon);
