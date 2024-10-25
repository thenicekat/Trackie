import React from 'react'
import { Tabs } from 'expo-router'
import { FontAwesome } from '@expo/vector-icons'
import Colors from '@/constants/Colors'
import { BlurView } from 'expo-blur'

const Layout = () => {
    return (
        <Tabs
            screenOptions={{
                tabBarActiveTintColor: Colors.primary,
                tabBarHideOnKeyboard: true,
                headerShown: false,
                tabBarBackground: () => <BlurView
                    intensity={100}
                    style={{
                        flex: 1,
                    }}
                />,
                tabBarStyle: {
                    backgroundColor: 'white',
                    position: 'absolute',
                    bottom: 0,
                    left: 0,
                    right: 0,
                    borderTopWidth: 0,
                    elevation: 0,
                    shadowOpacity: 0,
                }
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

            <Tabs.Screen name="edit/[id]" options={{
                title: 'Edit',
                tabBarIcon: ({ size, color }) => (<FontAwesome name='pencil' size={size} color={color} />),
                /* Disable one screen from showing in bottom bar */
                href: null
            }} />
        </Tabs>
    )
}

export default Layout