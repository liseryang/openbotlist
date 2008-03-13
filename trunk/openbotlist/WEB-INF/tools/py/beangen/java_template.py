########################################
# Html template
########################################

JAVA_HEADER_COPYRIGHT="""/**
 * Berlin Brown
 * Nov 9, 2006
 */
"""

JAVA_HEADER_CLASS="""
import java.io.Serializable;
import java.util.Calendar;

/**
 * This is class is used by botverse.
 * 
 * @author Berlin Brown
 * 
 */
"""

SPRING_CONFIG_DAO = """        <property name="sessionFactory">
			<ref local="sessionFactory" />
		</property>
	</bean>	
"""

HBM_ID_FIELD = """
        <id name="id" column="id">
            <generator class="native"/>
        </id>
"""


