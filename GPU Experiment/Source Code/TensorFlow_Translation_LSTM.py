#!/usr/bin/env python
# coding: utf-8

# In[1]:


#!/usr/bin/python
# -*- coding: utf-8 -*-
from __future__ import absolute_import, division, print_function
import tensorflow as tf
import LoggerYN as YN

from sklearn.model_selection import train_test_split
import unicodedata
import re
import numpy as np
import os
import time
import datetime
import sys

from keras import backend as K


# In[2]:


# Converts the unicode file to ascii
def unicode_to_ascii(s):
    return ''.join(c for c in unicodedata.normalize('NFD', s)
        if unicodedata.category(c) != 'Mn')


def preprocess_sentence(w):
    w = unicode_to_ascii(w.lower().strip())
    
    # creating a space between a word and the punctuation following it
    # eg: "he is a boy." => "he is a boy ." 
    # Reference:- https://stackoverflow.com/questions/3645931/python-padding-punctuation-with-white-spaces-keeping-punctuation
    w = re.sub(r"([?.!,¿])", r" \1 ", w)
    w = re.sub(r'[" "]+', " ", w)
    
    # replacing everything with space except (a-z, A-Z, ".", "?", "!", ",")
    w = re.sub(r"[^a-zA-Z?.!,¿]+", " ", w)
    
    w = w.rstrip().strip()
    
    # adding a start and an end token to the sentence
    # so that the model know when to start and stop predicting.
    w = '<start> ' + w + ' <end>'
    return w

# 1. Remove the accents
# 2. Clean the sentences
# 3. Return word pairs in the format: [ENGLISH, SPANISH]
def create_dataset(path):
    lines = open(path, encoding='UTF-8').read().strip().split('\n')
    word_pairs = [[preprocess_sentence(w) for w in l.split('\t')]  for l in lines[:100000]]
    
    return word_pairs

    # This class creates a word -> index mapping (e.g,. "dad" -> 5) and vice-versa 
# (e.g., 5 -> "dad") for each language,
class LanguageIndex():
    def __init__(self, lang):
        self.lang = lang
        self.word2idx = {}
        self.idx2word = {}
        self.vocab = set()

        self.create_index()
    
    def create_index(self):
        for phrase in self.lang:
            self.vocab.update(phrase.split(' '))

        self.vocab = sorted(self.vocab)

        self.word2idx['<pad>'] = 0
        for index, word in enumerate(self.vocab):
            self.word2idx[word] = index + 1

        for word, index in self.word2idx.items():
            self.idx2word[index] = word
def max_length(tensor):
    return max(len(t) for t in tensor)


def load_dataset(path):
    # creating cleaned input, output pairs
    pairs = create_dataset(path)

    # index language using the class defined above    
    inp_lang = LanguageIndex(sp for en, sp in pairs)
    targ_lang = LanguageIndex(en for en, sp in pairs)
    
    # Vectorize the input and target languages
    
    # Spanish sentences
    input_tensor = [[inp_lang.word2idx[s] for s in sp.split(' ')] for en, sp in pairs]
    
    # English sentences
    target_tensor = [[targ_lang.word2idx[s] for s in en.split(' ')] for en, sp in pairs]
    
    # Calculate max_length of input and output tensor
    # Here, we'll set those to the longest sentence in the dataset
    max_length_inp, max_length_tar = max_length(input_tensor), max_length(target_tensor)

    # Padding the input and output tensor to the maximum length
    input_tensor = tf.keras.preprocessing.sequence.pad_sequences(input_tensor, 
                                                                 maxlen=max_length_inp,
                                                                 padding='post')
    
    target_tensor = tf.keras.preprocessing.sequence.pad_sequences(target_tensor, 
                                                                  maxlen=max_length_tar, 
                                                                  padding='post')
    
    return input_tensor, target_tensor, inp_lang, targ_lang, max_length_inp, max_length_tar


# In[3]:


def create_db(path_to_file):
    input_tensor, target_tensor, inp_lang, targ_lang, max_length_inp, max_length_targ = load_dataset(path_to_file)
    # Creating training and validation sets using an 80-20 split
    input_tensor_train, input_tensor_val, target_tensor_train, target_tensor_val = train_test_split(input_tensor, target_tensor, test_size=0.2,random_state=42)
    vocab_inp_size = len(inp_lang.word2idx)
    vocab_tar_size = len(targ_lang.word2idx)
    return input_tensor_train, input_tensor_val, target_tensor_train, target_tensor_val,vocab_inp_size,vocab_tar_size,max_length_inp, max_length_targ


# In[4]:


class Model:
    def __init__(self, vocab_inp,vocab_tar, embedding_dim, units, batch_sz):
        self.batch_sz = batch_sz
        self.units = units
        self.embed_enc = tf.get_variable('embed_enc', (vocab_inp, embedding_dim))
        self.enc_cell =  tf.nn.rnn_cell.LSTMCell(self.units,initializer=lstm_kernel_initializer)
        self.embed_dec = tf.get_variable('embed_dec', (vocab_tar, embedding_dim))
        self.dec_cell =  tf.nn.rnn_cell.LSTMCell(self.units,initializer=lstm_kernel_initializer)
        self.fc = tf.layers.Dense(units = vocab_tar)
        
    def __call__(self, inp,tar):
        enc_emb = tf.nn.embedding_lookup(self.embed_enc, inp)
        _,state = tf.nn.dynamic_rnn(self.enc_cell,inputs=enc_emb,dtype=tf.float32)
        dec_emb = tf.nn.embedding_lookup(self.embed_dec, tar)
        output,_ = tf.nn.dynamic_rnn(self.enc_cell,inputs=dec_emb,dtype=tf.float32)
        preds = self.fc(output)
        return preds    
def lstm_kernel_initializer(shape, dtype, partition_info):
    hidden_size = shape[1] // 4
    input_size = shape[0] - hidden_size
    kernel = tf.glorot_uniform_initializer(seed=None)((input_size, shape[1]))
    recurrent = tf.orthogonal_initializer(seed=None)((hidden_size, shape[1]))
    return tf.concat([kernel, recurrent], axis=0)


# In[5]:


def loss_function(real, pred):
    loss = tf.nn.sparse_softmax_cross_entropy_with_logits(labels=real, logits=pred)
    return tf.reduce_mean(loss)


# In[6]:


def train(sess,input_tensor_train,target_tensor_train,N_BATCH,BATCH_SIZE,optimizer,loss_,inpu,targe):
    for batch in range(N_BATCH):
            start = BATCH_SIZE*batch
            end = (BATCH_SIZE*batch) + BATCH_SIZE
            inp = input_tensor_train[start :end]
            targ = target_tensor_train[start:end]
            loss,_=sess.run([loss_,optimizer],feed_dict={inpu:inp,targe:targ})
            if(batch % 300 ==0):
                print("Batch "+str(batch)+" Loss "+str(loss))
                sys.stdout.flush()


# In[7]:


def test(sess,input_tensor_train,target_tensor_train,N_BATCH,BATCH_SIZE,loss_,inpu,targe):
    t_loss = 0
    for batch in range(N_BATCH):
        start = BATCH_SIZE*batch
        end = (BATCH_SIZE*batch) + BATCH_SIZE
        inp = input_tensor_train[start :end]
        targ = target_tensor_train[start:end]
        loss = sess.run(loss_,feed_dict={inpu:inp,targe:targ})
        t_loss += loss
    print('Validation Perplexity :{:.4f}'.format(np.power(2,t_loss/batch)))
    print('Validation Loss :{:.4f}'.format(t_loss/batch))
    sys.stdout.flush()


# In[8]:


def acc(acc_,sess,input_tensor_train,target_tensor_train,N_BATCH,BATCH_SIZE,loss_,inpu,targe):
    total=0
    count=0
    for batch in range(N_BATCH):
        start = BATCH_SIZE*batch
        end = (BATCH_SIZE*batch) + BATCH_SIZE
        inp = input_tensor_train[start :end]
        targ = target_tensor_train[start:end]
        feed_dict={inpu:inp,targe:targ}
        acc_tensor = sess.run(acc_,feed_dict)        
        accu_i = np.mean(acc_tensor)
        total += accu_i
        count += 1
    print('Accuracy :{:.4f}'.format(total/count))
    sys.stdout.flush()


# In[9]:


def accuracy(y_true, y_pred):
    if not K.is_tensor(y_pred):
        y_pred = K.constant(y_pred)
        y_true = K.constant(y_true)
    y_true = K.cast(y_true, y_pred.dtype)
    return K.cast(K.equal(y_true, y_pred), K.floatx())

def acc_function(real, pred):
    prediction=tf.argmax(pred,-1)
    acc_tensor=accuracy(real,prediction)
    return acc_tensor


# In[10]:


def run(BATCH_SIZE, embedding_dim, units,  epochs):
    tf.set_random_seed(1)
    path_to_zip = tf.keras.utils.get_file('spa-eng.zip', origin='http://download.tensorflow.org/data/spa-eng.zip', extract=True)
    path_to_file = os.path.dirname(path_to_zip)+"/spa-eng/spa.txt"
    input_tensor_train, input_tensor_val, target_tensor_train, target_tensor_val,vocab_inp_size,vocab_tar_size,max_length_inp, max_length_targ = create_db(path_to_file)
    # Get parameters
    BUFFER_SIZE = len(input_tensor_train)
    N_BATCH = BUFFER_SIZE//BATCH_SIZE
    N_BATCH_VAL = len(input_tensor_val)//BATCH_SIZE

    train_samples = len(input_tensor_train)
    val_samples = len(input_tensor_val)
    #Loading data    
    data_train = tf.data.Dataset.from_tensor_slices((input_tensor_train, target_tensor_train)).shuffle(BUFFER_SIZE)
    data_train = data_train.batch(BATCH_SIZE, drop_remainder=True)
    data_val = tf.data.Dataset.from_tensor_slices((input_tensor_val, target_tensor_val)).shuffle(BUFFER_SIZE)
    data_val = data_val.batch(BATCH_SIZE, drop_remainder=True)
    
    # Model initiation
    model = Model(vocab_inp_size,vocab_tar_size,embedding_dim,units,BATCH_SIZE)
    inpu = tf.placeholder(tf.int32, [None, max_length_inp])
    targe = tf.placeholder(tf.int32, [None, max_length_targ])
    predictions = model(inpu,targe[:,:-1])
    
    loss_ = loss_function(targe[:,1:],predictions)
    acc_ = acc_function(targe[:,1:],predictions)

    optimizer = tf.train.AdamOptimizer(0.0001).minimize(loss_)
    sess = tf.Session()
    try: 
        with tf.device("/GPU:0") as dev:
            sess.run(tf.global_variables_initializer())
            start = time.time()
            epoch=0
            current_time = time.time()
            time_consumed=current_time-start
            memT,cpuT,gpuT = YN.StartLogger("TensorFlow_GPU","Manythings")
            test(sess,input_tensor_train,target_tensor_train,N_BATCH_VAL,BATCH_SIZE,loss_,inpu,targe)
            while (time_consumed <= 86400 and epoch <= epochs):
                print("Epoch ", epoch) 
                train(sess,input_tensor_train,target_tensor_train,N_BATCH,BATCH_SIZE,optimizer,loss_,inpu,targe)
                test(sess,input_tensor_train,target_tensor_train,N_BATCH_VAL,BATCH_SIZE,loss_,inpu,targe)
                acc(acc_,sess,input_tensor_train,target_tensor_train,N_BATCH_VAL,BATCH_SIZE,loss_,inpu,targe)
                epoch += 1
                time_consumed=(time.time())-start
                print("Time since beginning: ", str(datetime.timedelta(seconds=time_consumed)) )
                sys.stdout.flush()
                #if epoch % 20 == 0:
                    #saver = tf.train.Saver()
                    #saver.save(sess, './TensorFlow_PTB_LSTM_model_GPU')
            YN.EndLogger(memT,cpuT,gpuT)
            print("\n\nTotal Time Consumed: ", str(datetime.timedelta(seconds=time_consumed)))
            sys.stdout.flush()
            saver = tf.train.Saver()
            saver.save(sess, './TensorFlow_PTB_LSTM_model_Final_GPU')
    except:
        print('GPU not available')
        sys.stdout.flush()


# In[11]:


run(BATCH_SIZE = 128, embedding_dim = 256, units = 256,  epochs = 200)


# In[ ]:




