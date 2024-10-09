import { View, Text } from 'react-native'
import React from 'react'
import { Tabs } from 'expo-router'
import { FontAwesome } from '@expo/vector-icons'
import Colors from '@/constants/Colors'

const Layout = () => {
    return (
        <Tabs
            screenOptions={{
                tabBarActiveTintColor: Colors.primary
            }}
        >
            <Tabs.Screen name="expenses" options={{
                title: 'Expenses',
                tabBarIcon: ({ size, color }) => (<FontAwesome name='money' size={size} color={color} />)
            }} />
            <Tabs.Screen name="add" options={{
                title: 'Add',
                tabBarIcon: ({ size, color }) => (<FontAwesome name='plus' size={size} color={color} />)
            }} />
            <Tabs.Screen name="balance" options={{
                title: 'Balance',
                tabBarIcon: ({ size, color }) => (<FontAwesome name='bank' size={size} color={color} />)
            }} />
        </Tabs>
    )
}

export default Layout