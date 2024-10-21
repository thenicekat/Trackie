import React from 'react'
import { Tabs } from 'expo-router'
import { FontAwesome } from '@expo/vector-icons'
import Colors from '@/constants/Colors'

const Layout = () => {
    return (
        <Tabs
            screenOptions={{
                tabBarActiveTintColor: Colors.primary,
                headerShown: false,
            }}
        >

            <Tabs.Screen name="notes" options={{
                title: 'Notes',
                tabBarIcon: ({ size, color }) => (<FontAwesome name='sticky-note' size={size} color={color} />)
            }} />

            <Tabs.Screen name="create" options={{
                title: 'Create',
                tabBarIcon: ({ size, color }) => (<FontAwesome name='plus' size={size} color={color} />)
            }} />
        </Tabs>
    )
}

export default Layout