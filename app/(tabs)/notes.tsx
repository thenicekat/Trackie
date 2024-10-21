import { View, Text, StyleSheet, ScrollView, Alert, TextInput } from 'react-native'
import React from 'react'
import { Note, useNoteStore } from '@/store/noteStore'
import { defaultStyles } from '@/constants/Styles';
import tw from 'twrnc';
import { FontAwesome } from '@expo/vector-icons';


const notes = () => {
    const { name, notes, deleteNote } = useNoteStore();

    const [searchInput, setSearchInput] = React.useState('');
    const [filteredNotes, setFilteredNotes] = React.useState<Note[]>(notes);

    React.useEffect(() => {
        setFilteredNotes(notes.filter((note) => note.content.includes(searchInput) || note.title.includes(searchInput)));
    }, [searchInput, notes]);

    return (
        <ScrollView>
            <Text style={[defaultStyles.sectionHeader, { marginTop: 50 }]}>
                Hello! {name}
            </Text>

            <View style={tw`bg-gray-100 h-full p-4 w-full`}>
                <View style={tw`mb-4`}>
                    <Text style={tw`text-4xl font-bold`}>Your Notes.</Text>
                </View>

                <View style={tw`h-[1px] bg-slate-500 my-1 w-full`} />

                <View style={tw`flex-row my-2`}>
                    <TextInput
                        style={
                            tw`border-2 border-gray-300 p-3 w-full rounded-lg`
                        }
                        placeholder="Search."
                        keyboardType='default'
                        value={searchInput}
                        onChangeText={setSearchInput}
                    />
                </View>

                {
                    filteredNotes.length == 0 ?
                        <View>
                            <Text style={tw`text-xl m-2`}>No notes found.</Text>
                        </View>
                        : filteredNotes.map((note) => (
                            <View
                                key={note.id}
                                style={tw`bg-white p-2 my-2 rounded-lg flex-row justify-between`}
                            >

                                <View
                                    style={tw`flex-1 align-items-center justify-center p-2`}
                                >
                                    <Text style={tw`text-xl font-bold uppercase`}>{note.title}</Text>
                                    <Text style={tw`text-lg`}>{note.content}</Text>
                                </View>

                                <FontAwesome
                                    name="trash"
                                    size={30}
                                    color={'red'}
                                    style={tw`w-10 h-10 text-center m-2`}
                                    onPress={() => {
                                        deleteNote(note.id)
                                        Alert.alert('Note Deleted', 'Note has been deleted successfully.')
                                    }}
                                />
                            </View>
                        ))
                }
            </View>
        </ScrollView >
    )
}

export default notes