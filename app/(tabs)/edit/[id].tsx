import { View, Text, StyleSheet, KeyboardAvoidingView, Platform, TextInput, Alert, TouchableOpacity } from 'react-native'
import React, { useEffect } from 'react'
import { Note, useNoteState } from '@/store/noteStore'
import { defaultStyles } from '@/constants/Styles';
import tw from 'twrnc';
import Colors from '@/constants/Colors';
import { useLocalSearchParams, useRouter } from 'expo-router';
import { keyboardAvoidingBehavior, keyboardVerticalOffset } from '@/app/constants';
import Header from '@/components/Header';


const editNote = () => {
    const router = useRouter();

    const { id } = useLocalSearchParams();
    const { name, notes, updateNote } = useNoteState();
    const [editableNote, setEditableNote] = React.useState<Note | null>(null);
    const [titleInput, setTitleInput] = React.useState('');
    const [contentInput, setContentInput] = React.useState('');

    useEffect(() => {
        const note = notes.find((note) => note.id === id);
        if (!note) {
            router.replace('/(tabs)/notes')
            return
        }
        setEditableNote(note)
        setTitleInput(note.title)
        setContentInput(note.content)
    }, [id, notes])

    const editNote = () => {
        if (!editableNote) {
            router.replace('/(tabs)/notes')
            return
        }
        updateNote({ ...editableNote, title: titleInput, content: contentInput })
        setTitleInput('')
        setContentInput('')
        Alert.alert(
            'Note Edited!',
            'Your note has edited successfully.',
        )
        router.replace('/(tabs)/notes')
        return
    }

    return (
        <KeyboardAvoidingView
            keyboardVerticalOffset={keyboardVerticalOffset}
            style={{ flex: 1 }}
            behavior={keyboardAvoidingBehavior}
            key="editnote"
        >
            <Header />

            <View style={tw`bg-gray-100 h-full p-4 w-full`}>
                <View style={tw`mb-4`}>
                    <Text style={tw`text-4xl font-bold`}>Edit Note.</Text>
                </View>

                <View style={tw`h-[1px] bg-slate-500 my-1 w-full`} />


                <View style={defaultStyles.container}>
                    <View style={styles.inputContainer}>
                        <TextInput
                            style={[styles.smolInput, { flex: 1 }]}
                            placeholder="Please enter a title."
                            keyboardType='default'
                            value={titleInput}
                            onChangeText={setTitleInput}
                        />
                    </View>

                    <View style={styles.inputContainer}>
                        <TextInput
                            style={[styles.bigInput, {
                                flex: 1,
                                alignContent: 'flex-start',
                                verticalAlign: 'top'
                            }]}
                            placeholder="Please enter your note here."
                            keyboardType='default'
                            value={contentInput}
                            onChangeText={setContentInput}
                            multiline={true}
                        />
                    </View>

                    <TouchableOpacity
                        style={[defaultStyles.pillButton, { backgroundColor: Colors.primary, marginBottom: 20 }]}
                        onPress={editNote}
                    >
                        <Text style={defaultStyles.buttonText}>Edit.</Text>
                    </TouchableOpacity>
                </View >

            </View >
        </KeyboardAvoidingView>
    )
}

const styles = StyleSheet.create({
    inputContainer: {
        marginVertical: 20,
        flexDirection: 'row',
    },
    smolInput: {
        backgroundColor: Colors.lightGray,
        padding: 15,
        borderRadius: 16,
        fontSize: 18,
        marginRight: 10
    },
    bigInput: {
        backgroundColor: Colors.lightGray,
        padding: 15,
        borderRadius: 16,
        fontSize: 18,
        marginRight: 10,
        height: 200
    }
})

export default editNote