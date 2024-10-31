import { View, Text } from 'react-native'
import React from 'react'
import { defaultStyles } from '@/constants/Styles'
import { useNoteState } from '@/store/noteStore'
import { FontAwesome } from '@expo/vector-icons'
import tw from 'twrnc'
import { useRouter } from 'expo-router'

const Header = () => {
    const { name } = useNoteState()
    const router = useRouter()

    return (
        <View
            style={tw``}
        >
            <Text style={[defaultStyles.sectionHeader, { marginTop: 50 }]}>
                Hello! {name}
            </Text>

            <View style={{ position: 'absolute', top: 50, right: 20 }}>
                <FontAwesome
                    name="cog"
                    size={24}
                    color="black"
                    onPress={() => {
                        router.push('/settings')
                    }}
                />
            </View>
        </View >
    )
}

export default Header