import { View, Text, StyleSheet } from 'react-native'
import React from 'react'
import { useAssets } from 'expo-asset'
import { ResizeMode, Video } from 'expo-av'
import { TouchableOpacity } from 'react-native'
import { defaultStyles } from '@/constants/Styles'
import { Link } from 'expo-router'

const Page = () => {
    const [assets] = useAssets([require('@/assets/videos/intro.mp4')])
    return (
        <View style={styles.container}>
            {
                assets && (
                    <Video
                        resizeMode={ResizeMode.COVER}
                        source={{ uri: assets[0].uri }}
                        style={styles.video}
                        shouldPlay
                        isLooping
                        isMuted
                    />
                )
            }

            <View style={{ marginTop: 80, padding: 20 }}>
                <Text style={[styles.header, { color: 'white' }]}>Note down. Your way.</Text>
            </View>

            <View style={styles.buttons}>
                <Link href={'/onboard'} style={[defaultStyles.pillButton, { flex: 1, backgroundColor: 'white' }]} asChild>
                    <TouchableOpacity>
                        <Text style={{ fontSize: 22, fontWeight: '500' }}>Get Started</Text>
                    </TouchableOpacity>
                </Link>
            </View>
        </View >
    )
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        justifyContent: 'space-between',
    },
    video: {
        width: '100%',
        height: '100%',
        position: 'absolute',
        opacity: 0.5,
    },
    header: {
        fontSize: 36,
        color: 'white',
        fontWeight: '900',
        textTransform: 'uppercase',
    },
    buttons: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        padding: 20,
        marginBottom: 40,
    }
})

export default Page